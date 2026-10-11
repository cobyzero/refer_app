import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/constants.dart';
import '../../../core/network/server_health.dart';
import '../../../core/utils/app_version.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/app_config.dart';
import '../repository/app_config_repository.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;
  final AppConfigRepository _configRepository;

  SplashBloc(this._authRepository, this._configRepository) : super(SplashInitial()) {
    on<SplashStarted>((event, emit) async {
      // 1. Fetch App Config. Si el servidor está caído -> mantenimiento.
      AppConfig? config;
      try {
        config = await _configRepository.getConfig();
      } on ServerDownException catch (e) {
        ServerHealth.reportDown();
        emit(SplashError(e.message));
        return;
      }
      // Sin config y sin excepción tipificada (p. ej. timeout no
      // clasificado): tratarlo como servidor caído, no como sesión válida.
      if (config == null) {
        ServerHealth.reportDown();
        emit(SplashError("System is under maintenance"));
        return;
      }
      // Moneda, impuesto y tarifa del operador (tabla app_settings).
      Money.currencyCode = config.currency;
      TaxConfig.enabled = config.taxEnabled;
      TaxConfig.rate = config.taxRate;
      ServiceFee.rate = config.serviceFeeRate;
      // Pagos de prueba autorizados por el operador (refer_web).
      PaymentsConfig.directConfirmAllowed = config.directConfirmEnabled;
      // Verificación OTP: con false, registro/login devuelven sesión directa
      // y la app salta la vista OTP (el operador lo apaga en refer_web o .env).
      EmailVerification.required = config.emailVerificationRequired;

      // 2. Chequeo de versión instalada vs API (GET /config).
      var updateStatus = UpdateStatus.ok;
      var installedVersion = '';
      try {
        installedVersion = (await PackageInfo.fromPlatform()).version;
        updateStatus = AppVersion.status(
          installed: installedVersion,
          apiVersion: config.version,
          apiMinVersion: config.minVersion,
        );
      } catch (_) {
        // Sin versión instalada legible: fail-open, no bloquear.
        updateStatus = UpdateStatus.ok;
      }

      if (updateStatus == UpdateStatus.force) {
        emit(
          SplashForceUpdate(
            minVersion: config.minVersion,
            installedVersion: installedVersion,
          ),
        );
        return;
      }

      // 3. Artificial delay for branding
      await Future.delayed(const Duration(seconds: 2));

      if (config.maintenance) {
        emit(SplashError("System is under maintenance"));
        return;
      }

      // 4. Validate Session (con aviso suave de update si aplica)
      final softUpdate =
          updateStatus == UpdateStatus.soft ? config.version : '';
      bool isValid;
      try {
        isValid = await _authRepository.validateToken();
      } on ServerDownException catch (e) {
        ServerHealth.reportDown();
        emit(SplashError(e.message));
        return;
      }

      if (isValid) {
        emit(
          SplashAuthenticated(
            updateAvailable: softUpdate.isNotEmpty,
            latestVersion: softUpdate,
          ),
        );
      } else {
        emit(
          SplashUnauthenticated(
            updateAvailable: softUpdate.isNotEmpty,
            latestVersion: softUpdate,
          ),
        );
      }
    });
  }
}

import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../../../core/network/server_health.dart';
import '../../../core/token_manager.dart';

/// Lanzada cuando el backend responde 403 EMAIL_NOT_VERIFIED (login)
/// o `needsVerification: true` (register). El UI debe navegar a la
/// pantalla de verificación OTP en lugar de mostrar "credenciales inválidas".
class EmailNotVerifiedException implements Exception {
  final String email;
  final String message;
  EmailNotVerifiedException(this.email, this.message);

  @override
  String toString() => 'EmailNotVerifiedException($email): $message';
}

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> signup(String name, String email, String password, {bool keepUpdated = false});
  Future<bool> validateToken();
  Future<void> logout();
  Future<bool> changePassword(String currentPassword, String newPassword);
  Future<bool> forgotPassword(String email);
  Future<bool> resetPassword(String email, String code, String newPassword);
  Future<bool> verifyEmail(String email, String code);
  Future<bool> resendVerification(String email);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  AuthRepositoryImpl({required this.apiClient, required this.tokenManager});

  @override
  Future<bool> validateToken() async {
    try {
      final token = await tokenManager.getAccessToken();
      if (token == null) return false;

      final response = await apiClient.dio.get('/auth/validate');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on ServerDownException {
      rethrow;
    } catch (e) {
      // Servidor caído: no borrar la sesión, propagar para mostrar
      // la vista de mantenimiento en lugar de cerrar sesión.
      if (ServerHealth.isServerDownError(e)) {
        throw ServerDownException(e.toString());
      }
      await tokenManager.deleteTokens();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await tokenManager.deleteTokens();
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['accessToken'];
        if (token != null) {
          await tokenManager.saveTokens(accessToken: token);
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 &&
          e.response?.data?['code'] == 'EMAIL_NOT_VERIFIED') {
        final message =
            e.response?.data?['message']?.toString() ??
            'Tu correo aún no está verificado. Revisa tu bandeja e ingresa el código.';
        throw EmailNotVerifiedException(email, message);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signup(String name, String email, String password, {bool keepUpdated = false}) async {
    try {
      final response = await apiClient.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'keepUpdated': keepUpdated,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // El backend con AUTOCONFIRM=false no devuelve token sino
        // { message, needsVerification: true, user }. Hay que verificar OTP.
        if (response.data?['needsVerification'] == true) {
          throw EmailNotVerifiedException(
            email,
            response.data?['message']?.toString() ??
                'Te enviamos un código de verificación. Revisa tu correo.',
          );
        }
        final token = response.data['accessToken'];
        if (token != null) {
          await tokenManager.saveTokens(accessToken: token);
          return true;
        }
      }
      return false;
    } on EmailNotVerifiedException {
      rethrow;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await apiClient.dio.post('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await apiClient.dio.post('/auth/forgot-password', data: {
        'email': email,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await apiClient.dio.post('/auth/reset-password', data: {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> verifyEmail(String email, String code) async {
    try {
      final response = await apiClient.dio.post('/auth/verify-email', data: {
        'email': email,
        'code': code,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si el backend devuelve token al verificar, guardar sesión
        // directamente. Si solo devuelve mensaje, el UI redirige al login.
        final data = response.data;
        final token = data is Map ? data['accessToken'] : null;
        if (token != null) {
          await tokenManager.saveTokens(accessToken: token as String);
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      // Re-lanzar con mensaje del backend para mostrarlo en el UI
      // (ej. "invalid or expired verification code").
      final backendMsg = e.response?.data is Map
          ? (e.response?.data['message']?.toString())
          : null;
      throw Exception(backendMsg ?? 'Código inválido o expirado');
    } catch (e) {
      if (e is Exception) rethrow;
      return false;
    }
  }

  @override
  Future<bool> resendVerification(String email) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/resend-verification',
        data: {'email': email},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError("Please fill in all fields"));
        return;
      }
      try {
        final success = await _repository.login(event.email, event.password);
        if (success) {
          emit(AuthAuthenticated());
        } else {
          emit(AuthError("Invalid credentials"));
        }
      } on EmailNotVerifiedException catch (e) {
        emit(AuthEmailNotVerified(e.email, e.message));
      } catch (_) {
        emit(AuthError("Invalid credentials"));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await _repository.signup(
          event.name,
          event.email,
          event.password,
        );
        if (success) {
          emit(AuthAuthenticated());
        } else {
          emit(AuthError("Error creating account"));
        }
      } on EmailNotVerifiedException catch (e) {
        emit(AuthEmailNotVerified(e.email, e.message));
      } catch (_) {
        emit(AuthError("Error creating account"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await _repository.logout();
      emit(AuthInitial());
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      if (event.email.isEmpty) {
        emit(AuthError("Please enter your email"));
        return;
      }
      final success = await _repository.forgotPassword(event.email);
      if (success) {
        emit(ForgotPasswordSuccess());
      } else {
        emit(AuthError("User not found or connection error"));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      if (event.email.isEmpty || event.code.isEmpty || event.newPassword.isEmpty) {
        emit(AuthError("Please fill in all fields"));
        return;
      }
      final success = await _repository.resetPassword(
        event.email,
        event.code,
        event.newPassword,
      );
      if (success) {
        emit(ResetPasswordSuccess());
      } else {
        emit(AuthError("Invalid code or reset failed"));
      }
    });

    on<VerifyEmailRequested>((event, emit) async {
      emit(AuthLoading());
      if (event.email.isEmpty || event.code.isEmpty) {
        emit(AuthError("Please enter the verification code"));
        return;
      }
      try {
        final success = await _repository.verifyEmail(event.email, event.code);
        if (success) {
          // Si verify-email devolvió accessToken, el repo ya guardó la
          // sesión. Intentar validar: si hay token, autenticar directo;
          // si no, pedir login de nuevo.
          final valid = await _repository.validateToken();
          if (valid) {
            emit(AuthAuthenticated());
          } else {
            emit(AuthEmailVerified(event.email));
          }
        } else {
          emit(AuthError("Invalid code or verification failed"));
        }
      } catch (e) {
        // El repo relanza con el mensaje del backend
        // (ej. "invalid or expired verification code").
        final msg = e.toString().replaceFirst('Exception: ', '');
        emit(AuthError(msg));
      }
    });

    on<ResendVerificationRequested>((event, emit) async {
      if (event.email.isEmpty) {
        emit(AuthError("Please enter your email"));
        return;
      }
      final success = await _repository.resendVerification(event.email);
      if (success) {
        emit(VerificationCodeSent("Verification code re-sent. Check your inbox."));
      } else {
        emit(AuthError("Could not resend the code. Try again."));
      }
    });
  }
}

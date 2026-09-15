abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class ForgotPasswordSuccess extends AuthState {}
class ResetPasswordSuccess extends AuthState {}

/// El login/register indicó que el email no está verificado.
/// El UI debe navegar a /verify-email?email=...
class AuthEmailNotVerified extends AuthState {
  final String email;
  final String message;
  AuthEmailNotVerified(this.email, this.message);
}

/// El OTP se verificó pero el backend no devolvió token:
/// el UI debe pedir al usuario iniciar sesión de nuevo.
class AuthEmailVerified extends AuthState {
  final String email;
  AuthEmailVerified(this.email);
}

/// Código de verificación reenviado.
class VerificationCodeSent extends AuthState {
  final String message;
  VerificationCodeSent(this.message);
}

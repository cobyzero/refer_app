abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;
  ResetPasswordRequested(this.email, this.code, this.newPassword);
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;
  VerifyEmailRequested(this.email, this.code);
}

class ResendVerificationRequested extends AuthEvent {
  final String email;
  ResendVerificationRequested(this.email);
}

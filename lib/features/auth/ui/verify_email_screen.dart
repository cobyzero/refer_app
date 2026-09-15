import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/core/widgets/app_snackbar.dart';
import '../../../core/di.dart';
import '../../../core/theme.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_header.dart';

/// Pantalla OTP para verificar el email después de login (403
/// EMAIL_NOT_VERIFIED) o register (needsVerification: true).
///
/// Uso: `/verify-email?email=foo@bar.com`
/// Endpoints: POST /auth/verify-email {email, code}
///            POST /auth/resend-verification {email}
class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _code = TextEditingController();
  final _codeFocus = FocusNode();
  String? _codeError;

  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  static const _resendCooldown = 30;

  @override
  void dispose() {
    _code.dispose();
    _codeFocus.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldownSeconds = _resendCooldown);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_cooldownSeconds <= 1) {
        t.cancel();
        setState(() => _cooldownSeconds = 0);
      } else {
        setState(() => _cooldownSeconds--);
      }
    });
  }

  void _submit(BuildContext blocContext, AppLocalizations l10n) {
    final code = _code.text.trim();
    setState(() {
      _codeError = code.length != 6 ? l10n.enter6DigitCode : null;
    });
    if (_codeError != null) {
      HapticFeedback.selectionClick();
      return;
    }
    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();
    blocContext.read<AuthBloc>().add(
          VerifyEmailRequested(widget.email, code),
        );
  }

  void _resend(BuildContext blocContext) {
    if (_cooldownSeconds > 0) return;
    HapticFeedback.selectionClick();
    blocContext.read<AuthBloc>().add(
          ResendVerificationRequested(widget.email),
        );
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
            onPressed: () => context.pop(),
            tooltip: l10n.back,
            style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        HapticFeedback.lightImpact();
                        AppSnackBar.success(
                          context,
                          l10n.emailVerifiedSuccess,
                        );
                        sl<CartBloc>().reconnect();
                        context.go('/main');
                      }
                      if (state is AuthEmailVerified) {
                        AppSnackBar.success(
                          context,
                          l10n.emailVerifiedSuccess,
                        );
                        // El backend no devolvió token: pedir login de nuevo.
                        context.go('/auth');
                      }
                      if (state is VerificationCodeSent) {
                        AppSnackBar.success(context, state.message);
                      }
                      if (state is AuthError) {
                        AppSnackBar.error(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthHeader(title: l10n.verifyEmailTitle),
                            const SizedBox(height: 16),
                            Text(
                              l10n.verifyEmailSubtitle(widget.email),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            AuthInputField(
                              label: l10n.verificationCode,
                              hint: l10n.enter6DigitCodeHint,
                              controller: _code,
                              focusNode: _codeFocus,
                              keyboardType: TextInputType.number,
                              autofillHints: const [
                                AutofillHints.oneTimeCode,
                              ],
                              textInputAction: TextInputAction.done,
                              errorText: _codeError,
                              prefixIcon: const Icon(
                                Icons.mark_email_read_outlined,
                                size: 20,
                              ),
                              onSubmitted: (_) => _submit(context, l10n),
                            ),
                            const SizedBox(height: 32),
                            Semantics(
                              button: true,
                              enabled: !isLoading,
                              label: l10n.verifyEmailAction,
                              child: FilledButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _submit(context, l10n),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppColors.primary
                                      .withValues(alpha: 0.5),
                                  minimumSize: const Size(
                                    double.infinity,
                                    52,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.verifyEmailAction,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.verified_outlined,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Reenviar con cooldown — 44pt target
                            Center(
                              child: TextButton(
                                onPressed: _cooldownSeconds > 0
                                    ? null
                                    : () => _resend(context),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(44, 44),
                                  tapTargetSize:
                                      MaterialTapTargetSize.padded,
                                ),
                                child: Text(
                                  _cooldownSeconds > 0
                                      ? l10n.resendCodeCooldown(
                                          _cooldownSeconds,
                                        )
                                      : l10n.resendCode,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

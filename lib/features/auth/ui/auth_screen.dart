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
import 'widgets/legal_text.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController(text: 'admin@admin.com');
  final _password = TextEditingController(text: 'admin123@');
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // HIG Writing: sentence case helper for legacy l10n that uses ALLCAPS
  String _toSentenceCase(String input) {
    if (input.isEmpty) return input;
    if (input == input.toUpperCase() && input.length <= 20) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }
    return input;
  }

  void _submit(BuildContext blocContext) {
    final l10n = AppLocalizations.of(context)!;
    final email = _email.text.trim();
    final password = _password.text;

    setState(() {
      _emailError = email.isEmpty || !email.contains('@')
          ? l10n.enterValidEmail
          : null;
      _passwordError = password.isEmpty ? l10n.enterPassword : null;
    });

    if (_emailError != null || _passwordError != null) {
      HapticFeedback.selectionClick();
      return;
    }

    // Dismiss keyboard, persist autofill
    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();

    blocContext.read<AuthBloc>().add(LoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  24 + MediaQuery.of(context).viewInsets.bottom * 0.1,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        HapticFeedback.lightImpact();
                        // El socket del carrito se creó al abrir la app (sin
                        // token); reconectar ahora con el token recién guardado.
                        sl<CartBloc>().reconnect();
                        context.go('/main');
                      }
                      if (state is AuthEmailNotVerified) {
                        AppSnackBar.error(context, state.message);
                        context.push(
                          '/verify-email?email=${Uri.encodeComponent(state.email)}',
                        );
                      }
                      if (state is AuthError) {
                        AppSnackBar.error(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return AutofillGroup(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const AuthHeader(),
                              const SizedBox(height: 32),

                              // Grouped form section — HIG Layout: group related items
                              // Inputs use white fill on off-white background for hierarchy
                              AuthInputField(
                                label: _toSentenceCase(l10n.email),
                                hint: l10n.emailHint,
                                controller: _email,
                                focusNode: _emailFocus,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [
                                  AutofillHints.email,
                                  AutofillHints.username,
                                ],
                                textInputAction: TextInputAction.next,
                                errorText: _emailError,
                                onSubmitted: (_) =>
                                    _passwordFocus.requestFocus(),
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              AuthInputField(
                                label: _toSentenceCase(l10n.password),
                                hint: l10n.enterPassword,
                                controller: _password,
                                focusNode: _passwordFocus,
                                isPassword: true,
                                autofillHints: const [AutofillHints.password],
                                textInputAction: TextInputAction.done,
                                errorText: _passwordError,
                                onSubmitted: (_) => _submit(context),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Forgot — 44pt target per HIG Accessibility
                              Align(
                                alignment: Alignment.centerRight,
                                child: Semantics(
                                  button: true,
                                  label: l10n.forgotPassword,
                                  child: TextButton(
                                    onPressed: () =>
                                        context.push('/forgot-password'),
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(44, 44),
                                      tapTargetSize:
                                          MaterialTapTargetSize.padded,
                                    ),
                                    child: Text(l10n.forgotPassword),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Primary CTA — 52pt high, semantic, haptics
                              Semantics(
                                button: true,
                                enabled: !isLoading,
                                label: l10n.signIn,
                                child: FilledButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _submit(context),
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
                                              l10n.signIn,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Divider + legal text — HIG Managing Accounts: explain value
                              _buildSignupLink(l10n),

                              const SizedBox(height: 16),
                              LegalText(
                                text: l10n.agreeTermsPrivacy(
                                  l10n.termsOfService,
                                  l10n.privacyPolicy,
                                ),
                                termsLabel: l10n.termsOfService,
                                privacyLabel: l10n.privacyPolicy,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.textTertiary,
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
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

  Widget _buildSignupLink(AppLocalizations l10n) {
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                l10n.dontHaveAccount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/signup'),
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 44),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              child: Text(
                _toSentenceCase(l10n.signUp),
                semanticsLabel: 'Sign up, create new account',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

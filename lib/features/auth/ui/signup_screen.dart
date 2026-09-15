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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _acceptTerms = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String _toSentenceCase(String input) {
    if (input.isEmpty) return input;
    if (input == input.toUpperCase() && input.length <= 30) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }
    return input;
  }

  void _submit(BuildContext blocContext, AppLocalizations l10n) {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pwd = _password.text;
    final confirm = _confirmPassword.text;

    setState(() {
      _nameError = name.isEmpty ? l10n.enterFullName : null;
      _emailError = email.isEmpty || !email.contains('@') ? l10n.enterValidEmail : null;
      _passwordError = pwd.length < 6 ? l10n.passwordMinLength : null;
      _confirmError = confirm != pwd ? l10n.passwordsDoNotMatch : null;
    });

    if ([_nameError, _emailError, _passwordError, _confirmError].any((e) => e != null)) {
      HapticFeedback.selectionClick();
      return;
    }

    if (!_acceptTerms) {
      AppSnackBar.error(context, l10n.pleaseAcceptTerms);
      return;
    }

    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();
    blocContext.read<AuthBloc>().add(RegisterRequested(name, email, pwd));
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        AppSnackBar.success(context, l10n.accountCreatedSuccess);
                        // Igual que en login: reconectar el socket del carrito
                        // con el token recién guardado.
                        sl<CartBloc>().reconnect();
                        context.go('/main');
                      }
                      if (state is AuthEmailNotVerified) {
                        AppSnackBar.success(context, state.message);
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthHeader(
                              title: l10n.createAccount,
                              subtitle: l10n.signupSubtitle,
                            ),
                            const SizedBox(height: 32),
                            AuthInputField(
                              label: _toSentenceCase(l10n.fullName),
                              hint: l10n.fullNameHint,
                              controller: _name,
                              focusNode: _nameFocus,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              errorText: _nameError,
                              prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                              onSubmitted: (_) => _emailFocus.requestFocus(),
                            ),
                            const SizedBox(height: 16),
                            AuthInputField(
                              label: _toSentenceCase(l10n.email),
                              hint: l10n.emailHint,
                              controller: _email,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              errorText: _emailError,
                              prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                              onSubmitted: (_) => _passwordFocus.requestFocus(),
                            ),
                            const SizedBox(height: 16),
                            AuthInputField(
                              label: _toSentenceCase(l10n.password),
                              hint: l10n.minimum6Chars,
                              controller: _password,
                              focusNode: _passwordFocus,
                              isPassword: true,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.next,
                              errorText: _passwordError,
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                              onSubmitted: (_) => _confirmFocus.requestFocus(),
                            ),
                            const SizedBox(height: 16),
                            AuthInputField(
                              label: _toSentenceCase(l10n.confirmPassword),
                              hint: l10n.repeatPassword,
                              controller: _confirmPassword,
                              focusNode: _confirmFocus,
                              isPassword: true,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              errorText: _confirmError,
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                              onSubmitted: (_) => _submit(context, l10n),
                            ),
                            const SizedBox(height: 20),
                            _buildCheckboxRow(
                              value: _acceptTerms,
                              onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                            ),
                            const SizedBox(height: 24),
                            Semantics(
                              button: true,
                              enabled: !isLoading,
                              label: l10n.createAccount,
                              child: FilledButton(
                                onPressed: isLoading ? null : () => _submit(context, l10n),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                                      )
                                    : Text(
                                        l10n.createAccount,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Secondary link — 44pt
                            TextButton(
                              onPressed: () => context.go('/auth'),
                              style: TextButton.styleFrom(
                                minimumSize: const Size(44, 44),
                                tapTargetSize: MaterialTapTargetSize.padded,
                              ),
                              child: Text(l10n.alreadyHaveAccount),
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

  Widget _buildCheckboxRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      container: true,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: const BorderSide(color: AppColors.separatorStrong, width: 1.4),
                  activeColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LegalText(
                  text: l10n.acceptTerms(
                    l10n.termsOfService,
                    l10n.privacyPolicy,
                  ),
                  termsLabel: l10n.termsOfService,
                  privacyLabel: l10n.privacyPolicy,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

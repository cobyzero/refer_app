import 'package:flutter/material.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../../core/theme.dart';

class AuthHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const AuthHeader({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _buildLogo(context),
        const SizedBox(height: 24),
        Text(
          title ?? l10n.welcomeBack,
          style: textTheme.displayMedium,
          textAlign: TextAlign.center,
          semanticsLabel: title ?? l10n.welcomeBack,
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            subtitle ?? l10n.welcomeSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Semantics(
      image: true,
      label: 'App logo',
      child: Container(
        height: 88,
        width: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.separator, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            'assets/images/refer_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.coffee_rounded, size: 36, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';
import '../../../core/utils/legal_launcher.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/bloc/locale_cubit.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_state.dart';
import '../../../core/di.dart';
import '../../splash/repository/app_config_repository.dart';
import '../../auth/repository/auth_repository.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/repository/cart_socket_manager.dart';
import '../../cart/bloc/locations_bloc.dart';
import '../../cart/bloc/locations_event.dart';
import '../../home/bloc/home_event.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 88;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0, scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(l10n.settings, style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: -0.2)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildProfileCard(l10n),
          const SizedBox(height: 24),
          _buildSectionHeader(l10n.account),
          _buildSettingsItem(icon: Icons.person_outline_rounded, title: l10n.personalInfo, onTap: () => context.push('/edit-profile')),
          const SizedBox(height: 24),
          _buildSectionHeader(l10n.preferences),
          _buildSettingsItem(icon: Icons.history_rounded, title: l10n.orderHistory, onTap: () => context.push('/order-history')),
          _buildSettingsItem(
            icon: Icons.translate_rounded, title: l10n.language,
            onTap: () => _showLanguageSelector(context, l10n),
            trailing: Text(Localizations.localeOf(context).languageCode == 'es' ? l10n.spanish : l10n.english, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(l10n.security),
          _buildSettingsItem(icon: Icons.lock_outline_rounded, title: l10n.changePassword, onTap: () => context.push('/change-password')),
          const SizedBox(height: 24),
          _buildSectionHeader(l10n.supportLegal),
          _buildSettingsItem(icon: Icons.help_outline_rounded, title: l10n.helpCenter, onTap: () => context.push('/help-center')),
          _buildSettingsItem(icon: Icons.gavel_outlined, title: l10n.termsOfService, onTap: () => openTermsOfService(context)),
          _buildSettingsItem(icon: Icons.privacy_tip_outlined, title: l10n.privacyPolicy, onTap: () => openPrivacyPolicy(context)),
          const SizedBox(height: 28),
          _buildSignOutButton(l10n),
          const SizedBox(height: 24),
          _buildVersionInfo(l10n),
        ]),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        final current = Localizations.localeOf(context).languageCode;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.separator, borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 16),
              Text(l10n.language, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
              const SizedBox(height: 12),
              _LanguageTile(label: l10n.english, selected: current == 'en', onTap: () { context.read<LocaleCubit>().changeLocale(const Locale('en')); Navigator.pop(context); }),
              _LanguageTile(label: l10n.spanish, selected: current == 'es', onTap: () { context.read<LocaleCubit>().changeLocale(const Locale('es')); Navigator.pop(context); }),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(AppLocalizations l10n) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      String name = 'Guest'; String? photoUrl; int stars = 0;
      if (state is HomeLoaded) { name = state.user.name; photoUrl = state.user.photoUrl; stars = state.summary.stars; }
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
        child: Row(children: [
          UserAvatar(photoUrl: photoUrl, name: name, radius: 32),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.2)),
            const SizedBox(height: 4),
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, color: Color(0xFFD4B16A), size: 16),
              const SizedBox(width: 4),
              Text('$stars ${l10n.stars}', style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ])),
          Container(
            height: 36, width: 36,
            decoration: BoxDecoration(color: AppColors.neutralGrouped, shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary), onPressed: () => context.push('/edit-profile'), tooltip: 'Edit profile', style: IconButton.styleFrom(minimumSize: const Size(36, 36))),
          ),
        ]),
      );
    });
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(title.toUpperCase(), style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.8)),
  );

  Widget _buildSettingsItem({required IconData icon, required String title, VoidCallback? onTap, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.separator),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Container(height: 36, width: 36, decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 20)),
          title: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
          trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(AppLocalizations l10n) => SizedBox(
    width: double.infinity, height: 52,
    child: OutlinedButton(
      onPressed: () {
        sl<AuthRepository>().logout();
        // Cerrar el socket del usuario saliente para no reutilizar
        // su conexión si otro usuario inicia sesión después.
        sl<CartSocketManager>().disconnect();
        context.read<HomeBloc>().add(HomeResetRequested());
        context.read<CartBloc>().add(CartCleared());
        context.read<LocationsBloc>().add(LocationsResetRequested());
        context.go('/auth');
      },
      style: OutlinedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.separator), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
        const SizedBox(width: 8),
        Text(l10n.signOut, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.error)),
      ]),
    ),
  );

  Widget _buildVersionInfo(AppLocalizations l10n) {
    final version = sl<AppConfigRepository>().cachedConfig?.version ?? '0.0.0';
    return Center(child: Text('${l10n.version} $version — Cobyzero Organization', style: GoogleFonts.outfit(color: AppColors.textTertiary, fontSize: 11, letterSpacing: 0.2)));
  }
}

class _LanguageTile extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _LanguageTile({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: selected ? AppColors.secondary.withValues(alpha: 0.5) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: selected ? AppColors.secondary : AppColors.separator),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          Expanded(child: Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? AppColors.primary : AppColors.text))),
          if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
        ]),
      ),
    ),
  );
}

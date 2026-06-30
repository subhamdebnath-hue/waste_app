import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../l10n/locale_controller.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_user_service.dart';
import '../../widgets/premium_ui.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?>? _userProfileFuture;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      _userProfileFuture = FirestoreUserService.instance.getUserDocument(
        user.uid,
      );
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);

    try {
      await AuthService.instance.signOut();

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } on AuthServiceException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.localizedErrorMessage(error.message))),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.logoutFailed)));
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  String _displayName(Map<String, dynamic>? data, AppLocalizations l10n) {
    final user = AuthService.instance.currentUser;
    final name = (data?['name'] as String?)?.trim();

    if (name != null && name.isNotEmpty) {
      return name;
    }

    return user?.displayName ?? l10n.wasteWiseUser;
  }

  String _displayEmail(Map<String, dynamic>? data, AppLocalizations l10n) {
    final user = AuthService.instance.currentUser;
    final email = (data?['email'] as String?)?.trim();

    if (email != null && email.isNotEmpty) {
      return email;
    }

    return user?.email ?? l10n.noEmailAvailable;
  }

  String _currentLanguageName(BuildContext context) {
    final l10n = context.l10n;
    final locale = LocaleScope.of(context).locale;

    return locale.languageCode == 'kn' ? l10n.kannada : l10n.english;
  }

  Future<void> _showLanguageDialog() async {
    final controller = LocaleScope.of(context);
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final selectedLanguageCode = controller.locale.languageCode;

        return SimpleDialog(
          title: Text(l10n.languageSettings),
          children: [
            ListTile(
              leading: Icon(
                selectedLanguageCode == 'en'
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
              title: Text(l10n.english),
              onTap: () async {
                await controller.setLocale(const Locale('en'));
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
              },
            ),
            ListTile(
              leading: Icon(
                selectedLanguageCode == 'kn'
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
              title: Text(l10n.kannada),
              onTap: () async {
                await controller.setLocale(const Locale('kn'));
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final l10n = context.l10n;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: PremiumBackground(
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _userProfileFuture,
            builder: (context, snapshot) {
              final data = snapshot.data;
              final name = _displayName(data, l10n);
              final email = _displayEmail(data, l10n);
              final provider = (data?['authProvider'] as String?) ?? 'firebase';
              final profileCompleted =
                  (data?['profileCompleted'] as bool?) ?? false;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 108),
                children: [
                  FrostedCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        ProfileAvatar(label: name, size: 62),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(title: l10n.account),
                  const SizedBox(height: 12),
                  FrostedCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.badge_outlined,
                          title: l10n.userId,
                          value: user.uid,
                        ),
                        const _SectionDivider(),
                        _SettingsRow(
                          icon: Icons.verified_user_outlined,
                          title: l10n.provider,
                          value: provider,
                        ),
                        const _SectionDivider(),
                        _SettingsRow(
                          icon: Icons.task_alt_outlined,
                          title: l10n.profile,
                          value: profileCompleted
                              ? l10n.complete
                              : l10n.notComplete,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(title: l10n.settings),
                  const SizedBox(height: 12),
                  FrostedCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.language_rounded,
                          title: l10n.language,
                          value: _currentLanguageName(context),
                          onTap: _showLanguageDialog,
                          showChevron: true,
                        ),
                        const _SectionDivider(),
                        _SettingsRow(
                          icon: Icons.notifications_none_rounded,
                          title: l10n.notifications,
                          value: l10n.iteration2,
                        ),
                        const _SectionDivider(),
                        _SettingsRow(
                          icon: Icons.privacy_tip_outlined,
                          title: l10n.privacy,
                          value: l10n.soon,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoggingOut ? null : _logout,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.destructive,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoggingOut
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.logout),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.showChevron = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: 12,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 21),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 170),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 72, color: AppColors.border);
  }
}

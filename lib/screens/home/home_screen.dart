import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_user_service.dart';
import '../../widgets/premium_ui.dart';
import '../auth/login_screen.dart';

// Main dashboard with protected Firebase user data and placeholder actions.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onScanWaste, this.onFindRecyclingCenter});

  final VoidCallback? onScanWaste;
  final VoidCallback? onFindRecyclingCenter;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?>? _userProfileFuture;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = AuthService.instance.currentUser;

    if (user == null) {
      _redirectToLogin();
      return;
    }

    _userProfileFuture = FirestoreUserService.instance.getUserDocument(
      user.uid,
    );
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    });
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.featureComingIteration2)),
    );
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

  String _formattedDate(AppLocalizations l10n) {
    final months = [
      l10n.monthJanuary,
      l10n.monthFebruary,
      l10n.monthMarch,
      l10n.monthApril,
      l10n.monthMay,
      l10n.monthJune,
      l10n.monthJuly,
      l10n.monthAugust,
      l10n.monthSeptember,
      l10n.monthOctober,
      l10n.monthNovember,
      l10n.monthDecember,
    ];
    final now = DateTime.now();
    return l10n.dateFormat(months[now.month - 1], now.day, now.year);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final l10n = context.l10n;

    if (user == null) {
      _redirectToLogin();
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.logout,
            onPressed: _isLoggingOut ? null : _logout,
            icon: _isLoggingOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PremiumBackground(
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _userProfileFuture,
            builder: (context, snapshot) {
              final data = snapshot.data;
              final name = _displayName(data, l10n);
              final email = _displayEmail(data, l10n);

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 108),
                children: [
                  _Header(name: name, email: email, date: _formattedDate(l10n)),
                  const SizedBox(height: 28),
                  SectionHeader(title: l10n.quickActions),
                  const SizedBox(height: 12),
                  FrostedCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ActionRow(
                          icon: Icons.document_scanner_outlined,
                          title: l10n.scanWaste,
                          onTap: () {
                            widget.onScanWaste?.call();
                          },
                        ),
                        const _SectionDivider(),
                        _ActionRow(
                          icon: Icons.location_on_outlined,
                          title: l10n.findRecyclingCenter,
                          onTap: () {
                            widget.onFindRecyclingCenter?.call();
                          },
                        ),
                        const _SectionDivider(),
                        _ActionRow(
                          icon: Icons.history_rounded,
                          title: l10n.viewHistory,
                          onTap: () => _showComingSoon(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(title: l10n.recentActivity),
                  const SizedBox(height: 12),
                  FrostedCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ActivityRow(
                          icon: Icons.inbox_outlined,
                          title: l10n.noRecentReports,
                          subtitle: l10n.newReportsAppearHere,
                        ),
                        const _SectionDivider(),
                        _ActivityRow(
                          icon: Icons.auto_awesome_outlined,
                          title: l10n.smartScanning,
                          subtitle: l10n.comingInIteration2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(title: l10n.statistics),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: MediaQuery.sizeOf(context).width > 620
                        ? 4
                        : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _MetricCard(label: l10n.recyclable, value: '0'),
                      _MetricCard(label: l10n.reports, value: '0'),
                      _MetricCard(label: l10n.points, value: '0'),
                      _MetricCard(label: l10n.impact, value: '0 kg'),
                    ],
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

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.email, required this.date});

  final String name;
  final String email;
  final String date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                l10n.helloUser(name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
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
        const SizedBox(width: 16),
        ProfileAvatar(label: name, size: 54),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: 14,
      leading: _ListIcon(icon: icon),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 14,
      leading: _ListIcon(icon: icon),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(16),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ListIcon extends StatelessWidget {
  const _ListIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.primary, size: 21),
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

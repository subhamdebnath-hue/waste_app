import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../scan/scan_screen.dart';
import 'map_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

// Hosts the protected bottom navigation tabs while preserving tab state.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _redirectIfUnauthenticated();
  }

  void _redirectIfUnauthenticated() {
    if (AuthService.instance.currentUser != null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    });
  }

  void _openMapTab() {
    setState(() => _selectedIndex = 2);
  }

  void _openScanTab() {
    setState(() => _selectedIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (AuthService.instance.currentUser == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            onScanWaste: _openScanTab,
            onFindRecyclingCenter: _openMapTab,
          ),
          ScanScreen(isActive: _selectedIndex == 1),
          const MapScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        elevation: 0,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.lightSurface,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.document_scanner_outlined),
            selectedIcon: const Icon(Icons.document_scanner_rounded),
            label: l10n.scan,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map_rounded),
            label: l10n.map,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

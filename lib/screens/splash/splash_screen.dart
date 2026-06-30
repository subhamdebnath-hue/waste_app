import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../services/auth_service.dart';
import '../../widgets/premium_ui.dart';
import '../auth/login_screen.dart';
import '../home/main_navigation_screen.dart';

// Initial brand screen shown before the user enters the app flow.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 3), _openNextScreen);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _openNextScreen() {
    if (!mounted) return;

    final destination = AuthService.instance.currentUser == null
        ? const LoginScreen()
        : const MainNavigationScreen();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Center(child: _SplashContent())),
    );
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WasteWiseLogo(size: 84, iconSize: 44),
          const SizedBox(height: 22),
          Text(l10n.appName, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          Text(
            l10n.smartWasteSegregation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

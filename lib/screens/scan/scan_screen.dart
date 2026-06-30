import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_theme.dart';
import '../../l10n/l10n.dart';
import 'image_preview_screen.dart';

enum _ScanError {
  permissionPermanent,
  permissionRequired,
  noCameraFound,
  unableToInitialize,
  cameraNotReady,
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isInitializing = true;
  bool _isCapturing = false;
  _ScanError? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.isActive) {
      _initializeCamera();
    } else {
      _isInitializing = false;
    }
  }

  @override
  void didUpdateWidget(covariant ScanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      debugPrint('ScanScreen: tab became active, initializing camera.');
      _initializeCamera();
    } else if (oldWidget.isActive && !widget.isActive) {
      debugPrint('ScanScreen: tab became inactive, disposing camera.');
      _disposeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    if (!widget.isActive ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      debugPrint('ScanScreen: app inactive, disposing camera.');
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('ScanScreen: app resumed, initializing camera.');
      _initializeCamera();
    }
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    _cameraController = null;
    debugPrint('ScanScreen: disposing camera controller.');
    await controller?.dispose();
  }

  Future<void> _initializeCamera() async {
    if (!widget.isActive) {
      debugPrint('ScanScreen: skipped initialization because tab is inactive.');
      return;
    }

    debugPrint('ScanScreen: requesting camera permission.');
    setState(() {
      _isInitializing = true;
      _error = null;
    });

    final permission = await Permission.camera.request();
    debugPrint('ScanScreen: camera permission status: $permission');
    if (!permission.isGranted) {
      setState(() {
        _isInitializing = false;
        _error = permission.isPermanentlyDenied
            ? _ScanError.permissionPermanent
            : _ScanError.permissionRequired;
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      debugPrint('ScanScreen: available cameras: ${cameras.length}');
      if (cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
          _error = _ScanError.noCameraFound;
        });
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      debugPrint(
        'ScanScreen: selected camera: ${backCamera.name}, '
        'direction: ${backCamera.lensDirection}',
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _disposeCamera();
      debugPrint('ScanScreen: initializing camera controller.');
      await controller.initialize();
      debugPrint(
        'ScanScreen: camera initialized. Preview size: '
        '${controller.value.previewSize}, aspect: ${controller.value.aspectRatio}',
      );

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isInitializing = false;
      });
    } catch (error, stackTrace) {
      debugPrint('ScanScreen: camera initialization failed: $error');
      debugPrint('$stackTrace');
      setState(() {
        _isInitializing = false;
        _error = _ScanError.unableToInitialize;
      });
    }
  }

  Future<void> _captureImage() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      final image = await controller.takePicture();

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ImagePreviewScreen(imagePath: image.path),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unableToCaptureImage)),
      );
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.scan),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return _PermissionState(error: _error!, onRetry: _initializeCamera);
    }

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return _PermissionState(
        error: _ScanError.cameraNotReady,
        onRetry: _initializeCamera,
      );
    }

    return Stack(
      children: [
        Positioned.fill(child: _CameraPreviewView(controller: controller)),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.22),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.34),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 28,
          child: SafeArea(
            child: Center(
              child: _CaptureButton(
                isCapturing: _isCapturing,
                onPressed: _captureImage,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraPreviewView extends StatelessWidget {
  const _CameraPreviewView({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize?.height ?? 1,
            height: controller.value.previewSize?.width ?? 1,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.isCapturing, required this.onPressed});

  final bool isCapturing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: FilledButton(
        onPressed: isCapturing ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.72),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: isCapturing
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
      ),
    );
  }
}

class _PermissionState extends StatelessWidget {
  const _PermissionState({required this.error, required this.onRetry});

  final _ScanError error;
  final VoidCallback onRetry;

  String _message(BuildContext context) {
    final l10n = context.l10n;

    return switch (error) {
      _ScanError.permissionPermanent => l10n.cameraPermissionPermanent,
      _ScanError.permissionRequired => l10n.cameraPermissionRequired,
      _ScanError.noCameraFound => l10n.noCameraFound,
      _ScanError.unableToInitialize => l10n.unableToInitializeCamera,
      _ScanError.cameraNotReady => l10n.cameraNotReady,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 54,
            ),
            const SizedBox(height: 18),
            Text(
              _message(context),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 22),
            FilledButton(onPressed: onRetry, child: Text(l10n.tryAgain)),
            TextButton(
              onPressed: openAppSettings,
              child: Text(l10n.openSettings),
            ),
          ],
        ),
      ),
    );
  }
}

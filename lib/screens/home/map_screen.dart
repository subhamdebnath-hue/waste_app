import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../widgets/premium_ui.dart';

enum _LocationStatus {
  checking,
  servicesOff,
  permissionUnavailable,
  centered,
  unableToAccess,
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _position;
  _LocationStatus _locationStatus = _LocationStatus.checking;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationStatus = _LocationStatus.checking;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
          _locationStatus = _LocationStatus.servicesOff;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
          _locationStatus = _LocationStatus.permissionUnavailable;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _position = position;
        _isLoadingLocation = false;
        _locationStatus = _LocationStatus.centered;
      });
    } catch (_) {
      setState(() {
        _isLoadingLocation = false;
        _locationStatus = _LocationStatus.unableToAccess;
      });
    }
  }

  String _locationStatusText(BuildContext context) {
    final l10n = context.l10n;

    return switch (_locationStatus) {
      _LocationStatus.checking => l10n.checkingLocationPermission,
      _LocationStatus.servicesOff => l10n.locationServicesOff,
      _LocationStatus.permissionUnavailable =>
        l10n.locationPermissionUnavailable,
      _LocationStatus.centered => l10n.centeredOnCurrentLocation,
      _LocationStatus.unableToAccess => l10n.unableToAccessLocation,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.map)),
      body: PremiumBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 108),
            children: [
              Text(
                l10n.recyclingCenters,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.mapSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FrostedCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _MapMarker(isLoading: _isLoadingLocation),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.currentLocation,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _locationStatusText(context),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.refreshLocation,
                          onPressed: _isLoadingLocation
                              ? null
                              : _loadCurrentLocation,
                          icon: const Icon(Icons.my_location_rounded),
                        ),
                      ],
                    ),
                    if (_position != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        '${_position!.latitude.toStringAsFixed(5)}, '
                        '${_position!.longitude.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SectionHeader(title: l10n.nearbyRecyclingCenters),
              const SizedBox(height: 12),
              FrostedCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _CenterRow(
                      name: l10n.communityRecyclingHub,
                      detail: l10n.plasticPaperMetal,
                      distance: l10n.nearby,
                    ),
                    const _SectionDivider(),
                    _CenterRow(
                      name: l10n.greenDropOffPoint,
                      detail: l10n.eWasteDryWaste,
                      distance: l10n.nearby,
                    ),
                    const _SectionDivider(),
                    _CenterRow(
                      name: l10n.municipalCollectionCenter,
                      detail: l10n.mixedRecyclableWaste,
                      distance: l10n.nearby,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.location_on_rounded, color: AppColors.primary),
    );
  }
}

class _CenterRow extends StatelessWidget {
  const _CenterRow({
    required this.name,
    required this.detail,
    required this.distance,
  });

  final String name;
  final String detail;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 14,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.recycling_rounded,
          color: AppColors.primary,
          size: 21,
        ),
      ),
      title: Text(name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(detail),
      trailing: Text(distance, style: Theme.of(context).textTheme.bodySmall),
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

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

import '../../auth/domain/entity/user_type.dart';
import '../../auth/presentation/view_model/auth_state.dart';
import '../../auth/provider/auth_provider.dart';
import 'technician_location_service.dart';

class TechnicianTrackingCoordinator extends ConsumerStatefulWidget {
  const TechnicianTrackingCoordinator({
    required this.child,
    this.navigatorKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  ConsumerState<TechnicianTrackingCoordinator> createState() =>
      _TechnicianTrackingCoordinatorState();
}

class _TechnicianTrackingCoordinatorState
    extends ConsumerState<TechnicianTrackingCoordinator> {
  late final ProviderSubscription<AuthState> _authSubscription;
  bool _trackingActive = false;

  @override
  void initState() {
    super.initState();
    _authSubscription = ref.listenManual<AuthState>(authViewModelProvider, (
      previous,
      next,
    ) {
      unawaited(_handleAuthStateChange(next));
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _authSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> _handleAuthStateChange(AuthState state) async {
    if (!mounted) {
      return;
    }

    if (state is! AuthenticatedState ||
        state.user.userType != UserType.technician) {
      if (_trackingActive) {
        await TechnicianLocationService.stopTracking();
        _trackingActive = false;
      }
      return;
    }

    final authState = state;
    final permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      if (_trackingActive) {
        await TechnicianLocationService.stopTracking();
        _trackingActive = false;
      }
      return;
    }

    await TechnicianLocationService.startTracking(
      technicianId: authState.user.oracleId,
      authToken: authState.jwtToken,
    );
    _trackingActive = true;
  }

  Future<bool> _requestPermissions() async {
    if (kIsWeb) {
      return false;
    }

    final locationGranted = await _ensureLocationPermission();
    if (!locationGranted) {
      return false;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      final notificationGranted = await _ensureNotificationPermission();
      if (!notificationGranted) {
        return false;
      }
    }

    return true;
  }

  Future<bool> _ensureLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      final openSettings = await _showPermissionDialog(
        title: 'Enable Location Services',
        message:
            'Location services must stay on so we can keep sharing your position.',
        confirmLabel: 'Open Settings',
      );
      if (openSettings) {
        await Geolocator.openLocationSettings();
      }
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final allow = await _showPermissionDialog(
        title: 'Allow Location Access',
        message:
            'We need your permission to access location data while you are on duty.',
      );
      if (!allow) {
        return false;
      }
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      final openSettings = await _showPermissionDialog(
        title: 'Location Permission Needed',
        message:
            'Please enable location permissions in Settings to continue tracking.',
        confirmLabel: 'Open Settings',
      );
      if (openSettings) {
        await Geolocator.openAppSettings();
      }
      return false;
    }

    if (Platform.isAndroid) {
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> _ensureNotificationPermission() async {
    if (!Platform.isAndroid) {
      // iOS does not rely on a foreground notification for tracking.
      return true;
    }
    final status = await permissions.Permission.notification.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }

    final allow = await _showPermissionDialog(
      title: 'Allow Notifications',
      message:
          'We show a persistent notification while tracking is active. Please allow notifications.',
    );
    if (!allow) {
      return false;
    }

    final result = await permissions.Permission.notification.request();
    if (result.isGranted || result.isLimited) {
      return true;
    }

    if (result.isPermanentlyDenied) {
      final openSettings = await _showPermissionDialog(
        title: 'Notification Permission Needed',
        message:
            'Enable notifications in Settings so the app can run a foreground service.',
        confirmLabel: 'Open Settings',
      );
      if (openSettings) {
        await permissions.openAppSettings();
      }
    }

    return false;
  }

  Future<bool> _showPermissionDialog({
    required String title,
    required String message,
    String? confirmLabel,
  }) async {
    if (!mounted) {
      return false;
    }

    final dialogContext = widget.navigatorKey?.currentContext ?? context;
    if (dialogContext == null) {
      return false;
    }

    final result = await showDialog<bool>(
      context: dialogContext,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Not now'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(confirmLabel ?? 'Allow'),
              ),
            ],
          ),
    );

    return result ?? false;
  }
}

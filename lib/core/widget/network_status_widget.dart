import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

/// Small abstraction around [Connectivity] so network state handling can be
/// tested without a platform channel.
abstract interface class NetworkConnectivity {
  Future<List<ConnectivityResult>> checkConnectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class ConnectivityPlusNetworkConnectivity implements NetworkConnectivity {
  ConnectivityPlusNetworkConnectivity({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return _connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({
    super.key,
    required this.child,
    this.connectivity,
    this.offlineConfirmationDelay = const Duration(seconds: 2),
    this.onlineMessageDuration = const Duration(seconds: 3),
  });

  final Widget child;
  final NetworkConnectivity? connectivity;

  /// A short delay avoids false offline alerts from transient platform events,
  /// which are especially common while iOS changes network interfaces.
  final Duration offlineConfirmationDelay;
  final Duration onlineMessageDuration;

  @override
  State<NetworkStatusWidget> createState() => NetworkStatusWidgetState();
}

class NetworkStatusWidgetState extends State<NetworkStatusWidget>
    with WidgetsBindingObserver {
  late final NetworkConnectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _isConnected = true;
  bool _showMessage = false;
  int _updateId = 0;
  Timer? _offlineConfirmationTimer;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivity =
        widget.connectivity ?? ConnectivityPlusNetworkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityEvent,
      onError: _handleConnectivityError,
    );
    unawaited(_refreshConnectivity());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshConnectivity());
    }
  }

  Future<void> _refreshConnectivity() async {
    final updateId = ++_updateId;

    try {
      final result = await _connectivity.checkConnectivity();
      if (!mounted || updateId != _updateId) return;
      _processConnectivityResult(result, updateId);
    } catch (error, stackTrace) {
      // A platform-channel failure does not prove that the device is offline.
      // Keep the last confirmed state instead of showing a false warning.
      debugPrint('Unable to check network connectivity: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleConnectivityEvent(List<ConnectivityResult> result) {
    final updateId = ++_updateId;
    _processConnectivityResult(result, updateId);
  }

  void _handleConnectivityError(Object error, StackTrace stackTrace) {
    debugPrint('Network connectivity stream failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  void _processConnectivityResult(
    List<ConnectivityResult> result,
    int updateId,
  ) {
    if (_hasNetworkTransport(result)) {
      _markConnected();
      return;
    }

    _scheduleOfflineConfirmation(updateId);
  }

  bool _hasNetworkTransport(List<ConnectivityResult> result) {
    // `other` and `bluetooth` can also provide internet access. The plugin
    // guarantees that `none` is the only value when no transport is available.
    return result.any((status) => status != ConnectivityResult.none);
  }

  void _scheduleOfflineConfirmation(int updateId) {
    _offlineConfirmationTimer?.cancel();
    _offlineConfirmationTimer = Timer(widget.offlineConfirmationDelay, () {
      unawaited(_confirmOffline(updateId));
    });
  }

  Future<void> _confirmOffline(int updateId) async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!mounted || updateId != _updateId) return;

      if (_hasNetworkTransport(result)) {
        _markConnected();
      } else {
        _markDisconnected();
      }
    } catch (error, stackTrace) {
      // Do not turn an API/platform error into an offline alert.
      debugPrint('Unable to confirm offline status: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _markConnected() {
    _offlineConfirmationTimer?.cancel();

    if (_isConnected) return;

    _hideTimer?.cancel();
    setState(() {
      _isConnected = true;
      _showMessage = true;
    });

    _hideTimer = Timer(widget.onlineMessageDuration, () {
      if (!mounted) return;
      setState(() => _showMessage = false);
    });
  }

  void _markDisconnected() {
    _hideTimer?.cancel();

    if (!_isConnected && _showMessage) return;

    setState(() {
      _isConnected = false;
      _showMessage = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription.cancel());
    _offlineConfirmationTimer?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(horizontal: 16),
            child: IgnorePointer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder:
                    (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.25),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                child:
                    _showMessage
                        ? _NetworkStatusBanner(
                          key: ValueKey<bool>(_isConnected),
                          isConnected: _isConnected,
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NetworkStatusBanner extends StatelessWidget {
  const _NetworkStatusBanner({super.key, required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? Colors.green.shade700 : Colors.red.shade700;
    final message =
        isConnected
            ? S.of(context).backOnline
            : S.of(context).noInternetConnection;

    return Semantics(
      liveRegion: true,
      label: message,
      child: Material(
        color: color,
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

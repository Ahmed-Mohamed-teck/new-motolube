import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkStatusWidget extends StatefulWidget {
  final Widget child;

  const NetworkStatusWidget({super.key, required this.child});

  @override
  NetworkStatusWidgetState createState() => NetworkStatusWidgetState();
}

class NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true;
  bool _showMessage = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final isConnected = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn);

    if (_isConnected != isConnected) {
      setState(() {
        _isConnected = isConnected;
        _showMessage = true; // Show message on status change

        // Cancel any existing timer
        _hideTimer?.cancel();

        if (isConnected) {
          // If connected, hide the message after a delay
          _hideTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showMessage = false;
              });
            }
          });
        } else {
          // If disconnected, keep the message visible
        }
      });
    } else if (!isConnected && !_showMessage) {
      // If already disconnected and message is somehow hidden, show it
      setState(() {
        _showMessage = true;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showMessage)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<bool>(_isConnected), // Key for animation
                color: _isConnected ? Colors.green : Colors.red,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    _isConnected ? 'Back Online' : 'No Internet Connection',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

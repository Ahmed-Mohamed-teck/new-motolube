import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum PaymentWebViewResult { success, failure, cancelled }

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.bearerToken,
  });

  final String paymentUrl;
  final String? bearerToken;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isCompleted = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    final headers = <String, String>{};
    final token = widget.bearerToken?.trim();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF5F5F5))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onProgress: (progress) {
            setState(() => _progress = progress.clamp(0, 100) / 100);
          },
          onNavigationRequest: (request) {
            return _handleNavigation(request.url);
          },
          onWebResourceError: (_) {
            if (!_isCompleted && mounted) {
              _completeAndPop(PaymentWebViewResult.failure);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl), headers: headers);
  }

  NavigationDecision _handleNavigation(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return NavigationDecision.navigate;
    }

    final status =
        uri.queryParameters['status']?.toLowerCase().trim() ??
        (uri.pathSegments.isNotEmpty ? uri.pathSegments.last.toLowerCase() : '');

    if (status == 'success') {
      _completeAndPop(PaymentWebViewResult.success);
      return NavigationDecision.prevent;
    }

    if (status == 'failed' ||
        status == 'failure' ||
        status == 'error' ||
        status == 'cancelled' ||
        status == 'canceled') {
      _completeAndPop(PaymentWebViewResult.failure);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _completeAndPop(PaymentWebViewResult result) {
    if (_isCompleted) {
      return;
    }
    _isCompleted = true;
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  Future<bool> _handleWillPop() async {
    if (!_isCompleted) {
      _completeAndPop(PaymentWebViewResult.cancelled);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _completeAndPop(PaymentWebViewResult.cancelled),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: _isLoading
                ? LinearProgressIndicator(
                    value: _progress > 0 && _progress < 1 ? _progress : null,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}

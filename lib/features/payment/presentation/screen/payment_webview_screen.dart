import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum PaymentWebViewResult { success, failure, cancelled }

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.bearerToken,
    this.payFortParameters,
  });

  final String paymentUrl;
  final String? bearerToken;
  final Map<String, dynamic>? payFortParameters;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  InAppWebViewController? _controller;
  bool _isCompleted = false;
  bool _isLoading = true;
  double _progress = 0;
  bool _returnHandled = false;
  Map<String, String>? _capturedReturnBody;

  Map<String, String> get _headers {
    final map = <String, String>{'Referer': widget.paymentUrl};
    final token = widget.bearerToken?.trim();
    if (token != null && token.isNotEmpty) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
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
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.paymentUrl),
            headers: _headers,
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
            thirdPartyCookiesEnabled: true,
            clearCache: false,
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: false,
            allowsBackForwardNavigationGestures: true,
            iframeAllow: 'payment *; *',
            iframeAllowFullscreen: true,
            disableHorizontalScroll: false,
            disableVerticalScroll: false,
          ),
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final request = navigationAction.request;
            final uri = request.url;
            final method = request.method?.toUpperCase() ?? 'GET';
            if (uri != null) {
              final allow = _handleUrl(
                uri.toString(),
                method: method,
                postedData: request.body,
              );
              return allow
                  ? NavigationActionPolicy.ALLOW
                  : NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStart: (_, __) => setState(() => _isLoading = true),
          onLoadStop: (_, url) {
            setState(() => _isLoading = false);
            if (url != null) {
              _handleUrl(url.toString(), method: 'GET');
            }
          },
          onProgressChanged: (_, progress) {
            setState(() => _progress = progress / 100);
          },
          onLoadHttpError: (_, __, ___, ____) {},
        ),
      ),
    );
  }

  bool _handleUrl(
    String url, {
    required String method,
    Uint8List? postedData,
  }) {
    final uri = Uri.tryParse(url);
    if (uri == null) return true;

    final isReturnPage = uri.path.toLowerCase().contains('/payform/return');
    if (isReturnPage && !_returnHandled) {
      if (method == 'POST' && postedData != null) {
        _capturedReturnBody = _decodeUrlEncodedBody(postedData);
      }
      _returnHandled = true;
      _postReturn(uri, overrideBody: postedData);
      return false;
    }

    final status =
        uri.queryParameters['status']?.toLowerCase().trim() ??
        (uri.pathSegments.isNotEmpty ? uri.pathSegments.last.toLowerCase() : '');
    final responseCode = uri.queryParameters['response_code']?.trim();

    final isSuccess =
        status == 'success' ||
            responseCode == '14000' ||
            uri.path.toLowerCase().contains('/payform/success');
    final isFailure =
        status == 'failed' ||
            status == 'failure' ||
            status == 'error' ||
            status == 'cancelled' ||
            status == 'canceled';

    if (isSuccess) {
      _completeAndPop(PaymentWebViewResult.success);
      return false;
    }
    if (isFailure) {
      _completeAndPop(PaymentWebViewResult.failure);
      return false;
    }
    return true;
  }

  Future<void> _postReturn(
    Uri uri, {
    Uint8List? overrideBody,
  }) async {
    if (_controller == null) return;

    Uint8List body;
    if (overrideBody != null && overrideBody.isNotEmpty) {
      body = overrideBody;
    } else {
      final params = <String, String>{};
      params.addAll(uri.queryParameters.map((k, v) => MapEntry(k, v ?? '')));
      if (_capturedReturnBody != null) {
        params.addAll(_capturedReturnBody!);
      }
      final payfort = widget.payFortParameters;
      if (payfort != null) {
        payfort.forEach((key, value) {
          if (value != null) {
            params[key] = value.toString();
          }
        });
      }
      body = const Utf8Encoder().convert(Uri(queryParameters: params).query);
    }

    final token = widget.bearerToken?.trim();
    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Referer': widget.paymentUrl,
      'Origin': 'https://sbcheckout.payfort.com',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    await _controller!.loadUrl(
      urlRequest: URLRequest(
        url: WebUri(uri.toString()),
        method: 'POST',
        headers: headers,
        body: body,
      ),
    );
  }

  Map<String, String> _decodeUrlEncodedBody(Uint8List data) {
    try {
      final decoded = utf8.decode(data);
      final uri = Uri.parse('http://dummy/?$decoded');
      return uri.queryParameters.map((k, v) => MapEntry(k, v ?? ''));
    } catch (_) {
      return {};
    }
  }

  Future<bool> _handleWillPop() async {
    if (!_isCompleted) {
      _completeAndPop(PaymentWebViewResult.cancelled);
    }
    return false;
  }

  void _completeAndPop(PaymentWebViewResult result) {
    if (_isCompleted) return;
    _isCompleted = true;
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }
}

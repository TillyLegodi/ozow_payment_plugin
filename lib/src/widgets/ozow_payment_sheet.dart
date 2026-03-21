import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../ozow_config.dart';
import '../ozow_result.dart';
import '../ozow_url_builder.dart';
import 'ozow_loading_screen.dart';
import 'ozow_result_screen.dart';

class OzowPaymentSheet extends StatefulWidget {
  final OzowConfig config;
  final Function(OzowResult) onResult;

  const OzowPaymentSheet({
    super.key,
    required this.config,
    required this.onResult,
  });

  @override
  State<OzowPaymentSheet> createState() => _OzowPaymentSheetState();
}

class _OzowPaymentSheetState extends State<OzowPaymentSheet> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _resultHandled = false;
  OzowResult? _finalResult;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final paymentUrl = OzowUrlBuilder.build(widget.config);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) => _handleNavigation(request.url),
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  NavigationDecision _handleNavigation(String url) {
    if (_resultHandled) return NavigationDecision.prevent;

    final uri = Uri.parse(url);
    final lower = url.toLowerCase();

    if (lower.contains('/success') ||
        lower.contains('paymentstatus=complete') ||
        lower.contains('status=complete')) {
      _resultHandled = true;
      _showResult(
        OzowResult(
          status: OzowPaymentStatus.success,
          transactionId: uri.queryParameters['TransactionId'],
          reference: uri.queryParameters['TransactionReference'],
          rawParams: uri.queryParameters,
        ),
      );
      return NavigationDecision.prevent;
    }

    if (lower.contains('/cancel') ||
        lower.contains('paymentstatus=abandoned') ||
        lower.contains('status=abandoned')) {
      _resultHandled = true;
      _showResult(
        OzowResult(
          status: OzowPaymentStatus.cancelled,
          reference: uri.queryParameters['TransactionReference'],
          rawParams: uri.queryParameters,
        ),
      );
      return NavigationDecision.prevent;
    }

    if (lower.contains('/error') ||
        lower.contains('paymentstatus=error') ||
        lower.contains('status=error')) {
      _resultHandled = true;
      _showResult(
        OzowResult(
          status: OzowPaymentStatus.error,
          reference: uri.queryParameters['TransactionReference'],
          errorMessage: uri.queryParameters['ErrorMessage'] ?? 'Payment failed',
          rawParams: uri.queryParameters,
        ),
      );
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _showResult(OzowResult result) {
    if (mounted) setState(() => _finalResult = result);
  }

  void _closeWithResult(OzowResult result) {
    if (mounted) {
      Navigator.of(context).pop();
      widget.onResult(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show result screen
    if (_finalResult != null) {
      return OzowResultScreen(
        result: _finalResult!,
        onDone: () => _closeWithResult(_finalResult!),
        onRetry: _finalResult!.isError
            ? () {
                setState(() {
                  _finalResult = null;
                  _resultHandled = false;
                  _isLoading = true;
                });
                _initWebView();
              }
            : null,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABFA1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'OZOW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            if (!_resultHandled) {
              _resultHandled = true;
              Navigator.of(context).pop();
              widget.onResult(
                const OzowResult(status: OzowPaymentStatus.cancelled),
              );
            }
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const OzowLoadingScreen(),
        ],
      ),
    );
  }
}

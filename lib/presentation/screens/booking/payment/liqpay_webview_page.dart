import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiqpayWebViewPage extends StatefulWidget {
  final String data;
  final String signature;

  const LiqpayWebViewPage({
    super.key,
    required this.data,
    required this.signature,
  });

  @override
  State<LiqpayWebViewPage> createState() => _LiqpayWebViewPageState();
}

class _LiqpayWebViewPageState extends State<LiqpayWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('LiqPay start: $url');
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            debugPrint('LiqPay nav: ${request.url}');

            // Must match result_url from buildLiqpayParams
            if (request.url.startsWith('https://test.kinolive/payment_success')) {
              Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    _loadHtml();
  }

  void _loadHtml() {
    final html = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>LiqPay</title>
        </head>
        <body onload="document.forms[0].submit()">
          <form method="POST" action="https://www.liqpay.ua/api/3/checkout" accept-charset="utf-8">
            <input type="hidden" name="data" value="${widget.data}" />
            <input type="hidden" name="signature" value="${widget.signature}" />
            <noscript>
              <button type="submit">Оплатить</button>
            </noscript>
          </form>
        </body>
      </html>
      ''';

    _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiqPay test'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

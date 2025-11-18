import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiqPayWebViewPage extends StatefulWidget {
  final String data;
  final String signature;

  const LiqPayWebViewPage({
    super.key,
    required this.data,
    required this.signature,
  });

  @override
  State<LiqPayWebViewPage> createState() => _LiqPayWebViewPageState();
}

class _LiqPayWebViewPageState extends State<LiqPayWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  static const String _resultUrlPrefix =
      'https://test.kinolive/payment_success';

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
            final url = request.url;
            debugPrint('LiqPay nav: $url');

            if (url.startsWith(_resultUrlPrefix)) {
              final uri = Uri.parse(url);
              final status = uri.queryParameters['status'];
              final code = uri.queryParameters['code'];

              debugPrint('LiqPay result: status=$status, code=$code');

              final bool isSuccess =
                  status == 'success' || status == 'sandbox';

              if (isSuccess) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }

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
        centerTitle: true,
        title: const Text('Ticket payment'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

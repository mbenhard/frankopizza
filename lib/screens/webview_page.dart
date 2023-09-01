import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class webviewPage extends StatefulWidget {
  @override
  _webviewState createState() => _webviewState();
}

class _webviewState extends State<webviewPage> {
  bool passwordVisibility = true;
  late InAppWebViewController inAppWebViewController;
  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();
        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse("https://franko-pizza.sk/mobile")),
                onWebViewCreated: (InAppWebViewController controller) {
                  inAppWebViewController = controller;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
              ),
              _progress < 1
                  ? Container(
                      child: LinearProgressIndicator(
                        value: _progress,
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

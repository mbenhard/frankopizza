import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:franko/screens/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class webviewPage extends StatefulWidget {
  const webviewPage({super.key});

  @override
  _webviewState createState() => _webviewState();
}

class _webviewState extends State<webviewPage> {
  bool passwordVisibility = true;
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webViewController;
  String _username = '';
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<void> removeUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '');
  }

  @override
  void initState() {
    getUserName().then((value) {
      _username = value;
      print(_username);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await webViewController.canGoBack();
        if (isLastPage) {
          webViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                    url: Uri.parse("https://www.franko-pizza.sk/mobile")),
                initialOptions: options,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  EasyLoading.show();
                },
                onLoadError: (controller, url, txt, kk) {
                  EasyLoading.dismiss();
                },
                onLoadStop: (controller, url) async {
                  CookieManager.instance()
                      .getCookies(
                    url: Uri.parse('https://www.franko-pizza.sk'),
                  )
                      .then((value) async {
                    print('123456789');
                    print(_username.toString());
                    print('123456789');

                    if (!value.toString().contains(_username.toString())) {
                      removeUserName().then((value) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SignInPage(
                              v: 1,
                            ),
                          ),
                        );
                      });
                    }
                    EasyLoading.dismiss();
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print('8080808080808808');
                  print(consoleMessage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

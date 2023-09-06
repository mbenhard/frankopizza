import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:franko/screens/screen.dart';

class driverwebPage extends StatefulWidget {
  driverwebPage({super.key});
  late InAppWebViewController inAppWebViewController;
  late InAppWebViewController inAppWebViewController1;
  late InAppWebViewController inAppWebViewController2;
  @override
  State<driverwebPage> createState() => _driverwebPageState();
}

double _progress = 0;
late InAppWebViewController inAppWebViewController;
late InAppWebViewController inAppWebViewController1;
late InAppWebViewController inAppWebViewController2;
final GlobalKey webViewKey = GlobalKey();
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

String _username = '';

class _driverwebPageState extends State<driverwebPage> {
  bool passwordVisibility = true;

  @override
  void initState() {
    getUserName().then((value) {
      _username = value;
      print(_username);
    });

    super.initState();
  }

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Builder(builder: (context) {
      return InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://franko-pizza.sk/mobile")),
        onWebViewCreated: (InAppWebViewController controller) {
          inAppWebViewController = controller;
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {},
      );
    }),
    Builder(builder: (context) {
      return Container(
        child: InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse("https://www.franko-pizza.sk/cart/")),
          onWebViewCreated: (InAppWebViewController controller) {
            inAppWebViewController1 = controller;
          },
          onProgressChanged:
              (InAppWebViewController controller, int progress) {},
        ),
      );
    }),
    Builder(builder: (context) {
      return InAppWebView(
        key: webViewKey,
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.franko-pizza.sk/moj-ucet/")),
        initialOptions: options,
        onWebViewCreated: (controller) {
          inAppWebViewController2 = controller;
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
      );
    }),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          // type: BottomNavigationBarType.shifting,
          showSelectedLabels: false, //selected item
          showUnselectedLabels: false, //unselected item
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: '',
              activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xFF608736),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.shopping_cart,
                  )),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: '',
              backgroundColor: Color(0xFF608736),
              activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xFF608736),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.storefront_rounded)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: '',
              activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xFF608736),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.person,
                  )),
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Color(0xFF6C963F),
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:franko/screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
final GlobalKey webViewKey1 = GlobalKey();
final GlobalKey webViewKey2 = GlobalKey();
final GlobalKey webViewKey3 = GlobalKey();
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
  bool isLoading1 = true;
  bool isLoading2 = true;
  bool isLoading3 = true;

  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    getUserName().then((value) {
      _username = value;
      print(_username);
    });

    _pages = [
      InAppWebView(
        key: webViewKey1,
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://franko-pizza.sk/mobile")),
        onWebViewCreated: (InAppWebViewController controller) {
          inAppWebViewController = controller;
          controller.evaluateJavascript(source: '''
    var myButton = document.getElementsByClassName('single_add_to_cart_button button alt wp-element-button')[0];
    myButton.addEventListener('click', function() {
      // Call a JavaScript function to send an event to Flutter.
      window.flutter_inappwebview.callHandler('buttonClicked', {});
    });
  ''');
          controller.addJavaScriptHandler(
              handlerName: 'buttonClicked',
              callback: (List<dynamic> arguments) {
                print('rooooooooooooooood');
                inAppWebViewController1.reload();
              });
        },
        onLoadStop: (controller, url) async {
          inAppWebViewController1.reload();
          setState(() {
            isLoading1 = false;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {},
      ),
      InAppWebView(
        key: webViewKey2,
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.franko-pizza.sk/cart/")),
        onWebViewCreated: (InAppWebViewController controller) {
          inAppWebViewController1 = controller;
        },
        onLoadStop: (controller, url) async {
          setState(() {
            isLoading2 = false;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {},
      ),
      Builder(
        builder: (context) {
          return InAppWebView(
            key: webViewKey3,
            initialUrlRequest: URLRequest(
                url: Uri.parse("https://www.franko-pizza.sk/moj-ucet/")),
            initialOptions: options,
            onWebViewCreated: (controller) {
              inAppWebViewController2 = controller;
            },
            onLoadError: (controller, url, txt, kk) {},
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
              });
              setState(() {
                isLoading3 = false;
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              print('8080808080808808');
              print(consoleMessage);
            },
          );
        },
      )
    ];

    super.initState();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    Builder(builder: (context) {
      return InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://franko-pizza.sk/mobile")),
        onWebViewCreated: (InAppWebViewController controller) {
          inAppWebViewController = controller;
        },
        onLoadStop: (controller, url) async {},
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
  Future<void> saveCartCookiesId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart-id', id);
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      CookieManager.instance()
          .getCookies(
        url: Uri.parse('https://www.franko-pizza.sk/mobile/'),
      )
          .then((value) {
        value.forEach((element) async {
          if (element.name == 'woocommerce_cart_hash') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print(prefs.getString('cart-id'));
            if (prefs.getString('cart-id') != element.value) {
              setState(() {
                isLoading2 = true;
                inAppWebViewController1.reload();
              });
              saveCartCookiesId(element.value);
            }
          }
        });
      });
    }
    setState(() {
      currentPage = index;
    });
    /*pageController.jumpToPage(
      index,
    );*/
  }

  onPageChanged(int index) {
    setState(() {
      currentPage = index;
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
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              IndexedStack(
                index: currentPage,
                children: _pages,
              ),
              isLoading1 == false && isLoading2 == false && isLoading3 == false
                  ? const SizedBox()
                  : Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF608736),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          // type: BottomNavigationBarType.shifting,
          showSelectedLabels: false, //selected item
          showUnselectedLabels: false, //unselected item
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: '',
              activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF608736),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.shopping_cart,
                  )),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront),
              label: '',
              backgroundColor: const Color(0xFF608736),
              activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF608736),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.storefront_rounded)),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_2_outlined),
              label: '',
              activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF608736),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.person,
                  )),
            ),
          ],
          currentIndex: currentPage,
          backgroundColor: const Color(0xFF6C963F),
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

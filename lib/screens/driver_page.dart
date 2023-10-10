import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:franko/screens/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/cookies.dart';

class DriverWebPage extends StatefulWidget {
  DriverWebPage({super.key});
  @override
  State<DriverWebPage> createState() => _driverwebPageState();
}

class _driverwebPageState extends State<DriverWebPage> {
  late InAppWebViewController inAppWebViewController;
  late InAppWebViewController inAppWebViewController1;
  late InAppWebViewController inAppWebViewController2;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      cacheEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      sharedCookiesEnabled: true,
    ),
  );
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<void> removeUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '');
  }

  String _username = '';
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
        initialUrlRequest: URLRequest(
          url: Uri.parse("https://franko-pizza.sk/mobile"),
        ),
        onWebViewCreated: (InAppWebViewController controller) async {
          inAppWebViewController = controller;
        },
        /*onLoadStart: (controller, url) async {
          await controller.evaluateJavascript(source: """
              var style = document.createElement('style');
              style.innerHTML = ".qodef-mobile-header {
                      display: none !important;
               }
              .qodef-page-footer.qodef-split-footer {
                  display: none !important;
              }";
              document.head.appendChild(style);
            """);
        },*/
        /*onPageCommitVisible: ,*/
        initialOptions: options,
        onLoadStop: (controller, url) async {
          await controller.injectCSSCode(
              source:
                  '.qodef-mobile-header {display: none;} .qodef-page-footer.qodef-split-footer {display: none;}');
          setState(() {
            isLoading1 = false;
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print('111111111111111111111');
          print(consoleMessage.message);
        },
      ),
      InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.franko-pizza.sk/cart/")),
        onWebViewCreated: (InAppWebViewController controller) async {
          inAppWebViewController1 = controller;
        },
        initialOptions: options,
        onLoadStop: (controller, url) async {
          await controller.injectCSSCode(
              source:
                  '.qodef-mobile-header {display: none;} .qodef-page-footer.qodef-split-footer {display: none;} .woocommerce-orders-table tr td:first-child {display: none;}.woocommerce-orders-table__header.woocommerce-orders-table__header-order-number {display: none;}');
          /*await controller.evaluateJavascript(source: """
              var style = document.createElement('style');
              style.innerHTML = ".qodef-mobile-header {
                      display: none !important;
               }
              .qodef-page-footer .qodef-split-footer {
                  display: none !important;
              }";
              document.head.appendChild(style);
            """);*/
          setState(() {
            isLoading2 = false;
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print('222222222222222222222');
          print(consoleMessage.message);
        },
      ),
      InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse("https://www.franko-pizza.sk/moj-ucet/"),
        ),
        onWebViewCreated: (controller) async {
          inAppWebViewController2 = controller;
        },
        initialOptions: options,
        onLoadStart: (controller, url) async {
          /*await controller.evaluateJavascript(source: """
              var style = document.createElement('style');
              style.innerHTML = ".qodef-mobile-header {
                      display: none !important;
               }
              .qodef-page-footer.qodef-split-footer {
                  display: none !important;
              }";
              document.head.appendChild(style);
            """);*/
          setState(() {
            isLoading3 = true;
          });
        },
        onLoadError: (controller, url, txt, kk) {
          setState(() {
            isLoading3 = false;
          });
        },
        onLoadStop: (controller, url) async {
          await controller.injectCSSCode(
              source:
                  '.qodef-mobile-header {display: none;} .qodef-page-footer.qodef-split-footer {display: none;} .woocommerce-MyAccount-navigation-link {font-size: 18px;padding: 10px!important;}.woocommerce-MyAccount-navigation-link {text-transform: uppercase;font-weight: 500;}.woocommerce-MyAccount-navigation-link.is-active {font-weight: bold;background-color: #6c9640;padding: 10px 0 10px 0!important;width: 100%;}.woocommerce-MyAccount-navigation-link.woocommerce-MyAccount-navigation-link--downloads {display: none;}');
          CookieManager.instance()
              .getCookies(
            url: Uri.parse('https://www.franko-pizza.sk'),
          )
              .then((value) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //String username = prefs.getString('username') ?? '';
            if (!value.toString().contains(_username.toString())) {
              removeUserName().then((value) {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SignInPage(
                      v: 1,
                    ),
                  ),
                );
              });
            }
            /*if (!value.toString().contains(_username.toString()) &&
                username.isEmpty) {
              removeUserName().then((value) {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SignInPage(
                      v: 1,
                    ),
                  ),
                );
              });
            } else if (username.isNotEmpty && Platform.isIOS) {
              List<Cookie> retrievedCookies =
                  CookieStorage.getCookiesFromPrefs();
              retrievedCookies.forEach((element) {
                CookieManager.instance().setCookie(
                  url: Uri.parse('https://www.franko-pizza.sk/moj-ucet/'),
                  name: element.name,
                  value: element.value,
                );
              });
            }*/
          });
          setState(() {
            isLoading3 = false;
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print('333333333333333333333');
          print(consoleMessage.message);
        },
      ),
    ];

    super.initState();
  }

  Future<void> saveCartCookiesId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart-id', id);
  }

  Future<void> _onItemTapped(int index) async {
    if (index == 1) {
      CookieManager.instance()
          .getCookies(
        url: Uri.parse('https://www.franko-pizza.sk/mobile/'),
      )
          .then((value) {
        CookieStorage.saveCookiesToPrefs(value);
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
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
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
          // type: BottomNavigationBarType.,
          showSelectedLabels: false, //selected item
          showUnselectedLabels: false, //unselected item
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront),
              label: '',
              backgroundColor: const Color(0xFF608736),
              activeIcon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF608736),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.storefront_rounded),
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: '',
              activeIcon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF608736),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_2_outlined),
              label: '',
              activeIcon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF608736),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person,
                ),
              ),
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

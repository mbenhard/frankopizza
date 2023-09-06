import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

class _driverwebPageState extends State<driverwebPage> {
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
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.franko-pizza.sk/moj-ucet/")),
        onWebViewCreated: (InAppWebViewController controller) {
          inAppWebViewController2 = controller;
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {},
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_notify/wp_notify.dart';

import '../constants.dart';
import '../screens/screen.dart';
import '../widgets/widget.dart';

class SignInPage extends StatefulWidget {
  final int v;

  const SignInPage({super.key, required this.v});
  @override
  _SignInPageState createState() => _SignInPageState();
}

List<String> signup = <String>["VYTVORIŤ ÚČET", "SIGN UP", "sich anmelden"];
List<String> signin = <String>["PRIHLÁSIŤ", "SIGN IN", "ANMELDEN"];
List<String> welcome = <String>[
  "VITAJTE SPÄŤ!",
  "WELCOME BACK!",
  "WILLKOMMEN ZURÜCK!"
];

List<String> pass = <String>["Heslo", "Password", "Passwort"];

List<String> forget = <String>[
  "Zabudli ste heslo?",
  "Forgot Password?",
  "Passwort vergessen?"
];

List<String> remamber = <String>[
  "Pamätáte heslo?",
  "Remember Password?",
  "Passwort vergessen?"
];

class _SignInPageState extends State<SignInPage> {
  bool isPasswordVisible = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  HeadlessInAppWebView? headlessWebView;
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
  Future<void> setCredentials(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Logger().e(username);
    prefs.setString('username', username);
  }

  Future<void> setWpConfig(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      WPNotifyAPI.instance.api((request) {
        return request
            .wpNotifyStoreToken(
                token: prefs.getString('fcm')!, userId: int.tryParse(id))
            .then((value) {
          print(value.toJson());
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  _login() {
    EasyLoading.show();
    final String username = emailController.text;
    final String password = passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      headlessWebView?.webViewController.evaluateJavascript(source: '''
      document.getElementById('username').value = '$username';
   document.getElementById('password').value = '$password';
   document.getElementsByClassName('woocommerce-button button woocommerce-form-login__submit wp-element-button')[0].click();
''');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.show();
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest:
          URLRequest(url: Uri.parse("https://www.franko-pizza.sk/moj-ucet/")),
      onLoadStart: (controller, url) {
        print('******************* on start loading ***************');
      },
      onLoadError: (controller, url, txt, kk) {
        EasyLoading.dismiss();
      },
      onLoadStop: (controller, url) async {
        print('******************* onLoadStop ***************');
        CookieManager.instance()
            .getCookies(
          url: Uri.parse('https://www.franko-pizza.sk'),
        )
            .then((value) {
          EasyLoading.dismiss();
          if (emailController.text.isNotEmpty &&
              value.toString().contains(emailController.text)) {
            value.forEach((element) async {
              if (element.name.contains('wp_wcpt_session')) {
                String id = element.value
                    .toString()
                    .substring(0, element.value.toString().indexOf('%'));
                setWpConfig(id);
              }
            });

            setCredentials(emailController.text).then((value) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => DriverWebPage(),
                ),
              );
              print('logged id successfull');
            });
          } else if (emailController.text.isNotEmpty &&
              !value.toString().contains(emailController.text)) {
            Fluttertoast.showToast(
              msg: "Login failed!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM, // You can change the gravity
              timeInSecForIosWeb:
                  1, // Duration for which the toast should be visible
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        });
      },
      onConsoleMessage: (controller, consoleMessage) {
        print('8080808080808808');
        print(consoleMessage);
      },
    );
    headlessWebView?.run();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomePage(v: widget.v),
              ),
            );
          },
          icon: const Image(
            width: 24,
            color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        //to make page scrollable
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 140,
                      ),
                      Center(
                        child: Text(
                          welcome[widget.v],
                          style: kHeadline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MyTextField(
                        hintText: 'Email ',
                        inputType: TextInputType.text,
                        textEditingController: emailController,
                      ),
                      MyPasswordField(
                        textEditingController: passwordController,
                        isPasswordVisible: isPasswordVisible,
                        text: pass[widget.v],
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => forgetpasswordPage(
                                    v: widget.v,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              forget[widget.v],
                              style: kBodyText.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 65,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                MyTextButton(
                  buttonName: signin[widget.v],
                  onTap: _login,
                  bgColor: const Color(0xFF33481C),
                  textColor: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      remamber[widget.v],
                      style: kBodyText1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RegisterPage(v: widget.v),
                          ),
                        );
                      },
                      child: Text(
                        signup[widget.v],
                        style: kBodyText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 65,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

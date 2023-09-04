import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/screen.dart';
import '../widgets/widget.dart';

class RegisterPage extends StatefulWidget {
  final int v;

  const RegisterPage({super.key, required this.v});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

List<String> phone = <String>["Telefón", "Phone", "Telefon"];
List<String> name = <String>["Vaše meno", "Full name", "Voller Name"];

List<String> register = <String>["REGISTRÁCIA", "Register", "Registrieren"];
List<String> al = <String>[
  "Už máte účet?",
  "Already have an account?",
  "Haben Sie bereits ein Konto?"
];

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final GlobalKey webViewKey = GlobalKey();
  bool isLoggedIn = false;
  InAppWebViewController? webViewController;
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
  Future<void> setUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  _register() {
    final String email = emailController.text;
    final String password = passwordController.text;
    final String fullName = fullNameController.text;
    if (email.isNotEmpty && password.isNotEmpty && fullName.isNotEmpty) {
      //EasyLoading.show();
      print('okkokkokkoko');
      webViewController?.evaluateJavascript(source: '''
      document.getElementById('reg_username').value = '$fullName';
   document.getElementById('reg_email').value = '$email';
   document.getElementById('reg_password').value = '$password';
   document.getElementsByClassName('woocommerce-Button woocommerce-button button wp-element-button woocommerce-form-register__submit')[0].click();
''');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Center(
                            child: Text(
                              acc[widget.v],
                              style: kHeadline,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextField(
                            hintText: name[widget.v],
                            inputType: TextInputType.name,
                            textEditingController: fullNameController,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                            textEditingController: emailController,
                          ),
                          /*MyTextField(
                            hintText: phone[widget.v],
                            inputType: TextInputType.phone,
                          ),*/
                          MyPasswordField(
                            text: pass[widget.v],
                            isPasswordVisible: passwordVisibility,
                            textEditingController: passwordController,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    MyTextButton(
                      buttonName: register[widget.v],
                      onTap: _register,
                      bgColor: Color(0xFF33481C),
                      textColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          al[widget.v],
                          style: kBodyText1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignInPage(v: widget.v),
                              ),
                            );
                          },
                          child: Text(
                            signin[widget.v],
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
                    SizedBox(
                      height: 0,
                      child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                "https://www.franko-pizza.sk/moj-ucet/")),
                        initialOptions: options,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          print('0666006600606060');
                          EasyLoading.show();
                        },
                        onLoadError: (controller, url, txt, kk) {
                          print('0707070707070707');
                          EasyLoading.dismiss();
                        },
                        onLoadStop: (controller, url) async {
                          CookieManager.instance()
                              .getCookies(
                            url: Uri.parse('https://www.franko-pizza.sk'),
                          )
                              .then((value) {
                            print('coooooookies : ${value.toString()}');
                            EasyLoading.dismiss();
                            if (fullNameController.text.isNotEmpty &&
                                value
                                    .toString()
                                    .contains(fullNameController.text)) {
                              setUserName(fullNameController.text)
                                  .then((value) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => webviewPage(),
                                  ),
                                );
                                print('register id successfull');
                              });
                            } else if (fullNameController.text.isNotEmpty &&
                                !value
                                    .toString()
                                    .contains(fullNameController.text)) {
                              Fluttertoast.showToast(
                                msg: "Register failed!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity
                                    .BOTTOM, // You can change the gravity
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

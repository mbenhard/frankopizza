import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgetpasswordPage extends StatefulWidget {
  final int v;

  const forgetpasswordPage({super.key, required this.v});
  @override
  _forgetpasswordPageState createState() => _forgetpasswordPageState();
}

List<String> dont = <String>[
  "Nevadí! Stáva sa. Prosím, zadajte Váš email cez ktorý ste sa registrovali.",
  "Don’t worry! It happens. Please enter the email associated with your account.",
  "Aber keine Sorge! Das kommt vor. Bitte geben Sie die mit Ihrem Konto verknüpfte E-Mail-Adresse ein."
];
List<String> remember = <String>[
  "Pamätáte heslo?",
  "Remember Password?",
  "Passwort vergessen?"
];

class _forgetpasswordPageState extends State<forgetpasswordPage> {
  bool isPasswordVisible = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
  _login() {
    EasyLoading.show();
    final String username = emailController.text;
    final String password = passwordController.text;
    webViewController?.evaluateJavascript(source: '''
      document.getElementById('username').value = '$username';

   document.getElementsByClassName('woocommerce-Input woocommerce-Input--text input-text')[0].click();
''');
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
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 160,
                          ),
                          Center(
                            child: Text(
                              forget[widget.v],
                              style: kHeadline,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            dont[widget.v],
                            style: kBodyText1,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.text,
                            textEditingController: emailController,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    MyTextButton(
                      buttonName: signin[widget.v],
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => webviewPassPage(),
                          ),
                        );
                      },
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
                          remember[widget.v],
                          style: kBodyText1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignInPage(
                                  v: widget.v,
                                ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 0,
                      child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                "https://www.franko-pizza.sk/moj-ucet/lost-password/")),
                        initialOptions: options,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                          CookieManager.instance().deleteAllCookies();
                        },
                        onLoadStart: (controller, url) {
                          EasyLoading.show();
                        },
                        onLoadStop: (controller, url) async {
                          CookieManager.instance()
                              .getCookies(
                            url: Uri.parse(
                                'https://www.franko-pizza.sk/moj-ucet/lost-password/'),
                          )
                              .then((value) {
                            print('coooooookies : ${value.toString()}');
                            EasyLoading.dismiss();
                            if (emailController.text.isNotEmpty &&
                                value
                                    .toString()
                                    .contains(emailController.text)) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => webviewPassPage(),
                                ),
                              );
                              print('logged id successfull');
                            } else if (emailController.text.isNotEmpty &&
                                !value
                                    .toString()
                                    .contains(emailController.text)) {
                              Fluttertoast.showToast(
                                msg: "Login failed!",
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
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        onConsoleMessage: (controller, consoleMessage) {
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
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
                            height: 140,
                          ),
                          Center(
                            child: Text(
                              welcome[widget.v],
                              style: kHeadline,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyTextField(
                            hintText: 'Email ',
                            inputType: TextInputType.text,
                          ),
                          MyPasswordField(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    MyTextButton(
                      buttonName: signin[widget.v],
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => webviewPage(),
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
          ],
        ),
      ),
    );
  }
}

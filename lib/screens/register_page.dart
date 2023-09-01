import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';
import '../screens/screen.dart';
import '../constants.dart';
import 'package:flutter/cupertino.dart';

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
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyTextField(
                            hintText: phone[widget.v],
                            inputType: TextInputType.phone,
                          ),
                          MyPasswordField(
                            text: pass[widget.v],
                            isPasswordVisible: passwordVisibility,
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

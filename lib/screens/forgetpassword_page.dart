import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

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

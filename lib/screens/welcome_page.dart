import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import '../widgets/widget.dart';

List<String> sign = <String>["PRIHLÁSIŤ", "SIGN IN", "ANMELDEN"];
List<String> acc = <String>[
  "VYTVORIŤ ÚČET",
  'CREATE ACCOUNT',
  "KONTO ERSTELLEN"
];

class WelcomePage extends StatelessWidget {
  final int v;

  const WelcomePage({super.key, required this.v});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        reverse: true,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: const Image(
                              image: AssetImage('assets/images/Franko1.png'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 00),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xff303030),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          MyTextButton(
                            buttonName: sign[v],
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SignInPage(v: v),
                                ),
                              );
                            },
                            bgColor: Color(0xFF33481C),
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => RegisterPage(v: v),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(acc[v], style: kButtonText),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

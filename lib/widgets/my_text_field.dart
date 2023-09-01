import 'package:flutter/material.dart';

import '../constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.inputType,
    this.textEditingController,
  }) : super(key: key);
  final String hintText;
  final TextInputType inputType;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: textEditingController,
        style: kBodyText.copyWith(color: Colors.black),
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: kBodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

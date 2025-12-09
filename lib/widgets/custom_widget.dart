import 'package:flutter/material.dart';

Widget customTextFormField(
  Widget? prefixIcon,
  String? hintText,
  TextEditingController? controller,
  String? validatorText,

) {
  return TextFormField(
    controller: controller,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

      errorStyle: TextStyle(
        color: Colors.amberAccent,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amberAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amberAccent),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return validatorText;
      }
      return null;
    },
  );
}

Widget customElevatedButton(String text) {
  return SizedBox(
    height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
    ),
  );
}


class AppColors{
  static const Color scaffoldBackgroundColor = Colors.black;
}
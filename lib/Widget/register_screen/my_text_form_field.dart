import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  String text;
  double? border;
  TextEditingController? controller;
  TextInputType? keyboardType;
  MyTextFormField(
      {super.key, required this.text, required this.controller, this.border,this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) {
          return "Faild Input";
        }
        return null;
      },
      
      decoration: InputDecoration(
        hintText: text,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(border ?? 0)),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 17, 31),
            )),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(border ?? 0),
          // borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(border ?? 0)),
            borderSide: const BorderSide(
              width: 2,
              strokeAlign: 20,
              color: Color.fromARGB(255, 0, 17, 31),
            )),
      ),
    );
  }
}

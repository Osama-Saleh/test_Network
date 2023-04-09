import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:netwrok/Cubit/home_cubit.dart';

class MyElevatedButton extends StatelessWidget {
  MyElevatedButton({
    super.key,
    this.formKey,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
  });
  final String? text;
  GlobalKey<FormState>? formKey;
  Color? backgroundColor = new Color.fromARGB(255, 48, 119, 177);
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor)),
      child: Text(
        text!,
      ),
    );
  }
}

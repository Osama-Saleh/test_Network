import 'package:flutter/material.dart';
import 'package:netwrok/Cubit/home_cubit.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.formKey,
   
    required this.text,
    required this.onPressed
  });
  final String? text;
  final GlobalKey<FormState> formKey;
 
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPressed,
       
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
        Color.fromARGB(255, 48, 119, 177),
      )),
      child: Text(
        text!,
      ),
    );
  }
}

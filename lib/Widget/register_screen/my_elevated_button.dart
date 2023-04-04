import 'package:flutter/material.dart';
import 'package:netwrok/Cubit/home_cubit.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.formKey,
    required this.mailController,
    required this.passwrodController,
    required this.text,
  });
  final String? text;
  final GlobalKey<FormState> formKey;
  final TextEditingController mailController;
  final TextEditingController passwrodController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          HomeCubit.get(context).userRegisted(
              mail: mailController.text, password: passwrodController.text);
        }
      },
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
        Color.fromARGB(255, 48, 119, 177),
      )),
      child:  Text(
        text!,
      ),
    );
  }
}

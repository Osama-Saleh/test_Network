import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Widget/register_screen/my_elevated_button.dart';
import 'package:netwrok/Widget/register_screen/my_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var mialController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Receive an email to\nreset your password",
                textAlign: TextAlign.center,
              ),
              MyTextFormField(
                text: "mail",
                controller: mialController,
              ),
              MyElevatedButton(
                formKey: formKey,
                text: "Reset Password",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    HomeCubit.get(context)
                        .resetPassword(mail: mialController.text);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

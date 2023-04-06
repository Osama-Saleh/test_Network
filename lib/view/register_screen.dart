// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/Widget/register_screen/my_elevated_button.dart';
import 'package:netwrok/Widget/register_screen/my_text_form_field.dart';
import 'package:netwrok/storage/shared.dart';
import 'package:netwrok/view/button_app_bar.dart';
import 'package:netwrok/view/login_Screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var nameController = TextEditingController();
  var mailController = TextEditingController();
  var passwrodController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyButtonAppBarScreen(),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 17, 31),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(100))),
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 2.8,
                      top: MediaQuery.of(context).size.height / 4.5,
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/images/logo.jpg"),
                      )),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 2.8,
                      top: MediaQuery.of(context).size.height / 2.4,
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 30),
                      )),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyTextFormField(
                                controller: nameController,
                                text: "User Name",
                                keyboardType: TextInputType.name,
                                border: 15),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextFormField(
                                controller: mailController,
                                text: "Enter Your Mail",
                                keyboardType: TextInputType.emailAddress,
                                border: 15),
                            const SizedBox(
                              height: 10,
                            ),
                            MyTextFormField(
                                controller: passwrodController,
                                text: "Your Password",
                                keyboardType: TextInputType.number,
                                border: 15),
                            const SizedBox(
                              height: 10,
                            ),
                            MyElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  HomeCubit.get(context).userRegisted(
                                      name: nameController.text,
                                      mail: mailController.text,
                                      password: passwrodController.text);
                                }
                              },
                              text: "Sign Up",
                              formKey: formKey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("already have an account"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ));
                                    },
                                    child: const Text("Sing In"))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

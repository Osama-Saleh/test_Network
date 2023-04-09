// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/Widget/my_divider.dart';
import 'package:netwrok/Widget/register_screen/my_elevated_button.dart';
import 'package:netwrok/Widget/register_screen/my_text_form_field.dart';
import 'package:netwrok/constaint/constant.dart';
import 'package:netwrok/storage/shared.dart';
import 'package:netwrok/view/Home_Screen.dart';
import 'package:netwrok/view/button_app_bar.dart';
import 'package:netwrok/view/forget_pass_screen.dart';
import 'package:netwrok/view/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var mailController = TextEditingController();

  var passwrodController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool isChick = false;
  //*======================================================
  //*get remember mail and pass password in text form field
  //*======================================================

  void rememberData() {
    if (SharedPreference.getDataSt(key: "mail") != null) {
      mailController.text = SharedPreference.getDataSt(key: "mail").toString();
    }
    if (SharedPreference.getDataSt(key: "password") != null) {
      passwrodController.text =
          SharedPreference.getDataSt(key: "password").toString();
    }
  }

  @override
  void initState() {
    rememberData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is SigninSuccessState) {
          SharedPreference.saveData(Key: "uid", value: state.token)
              .then((value) {
            Constant.uid = SharedPreference.getDataSt(key: "uid");
            HomeCubit.get(context).getUserDate().then((value) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyButtonAppBarScreen(),
                  ));
            }).catchError((error) {
              print("Error : $error");
            });
          });
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
                      top: MediaQuery.of(context).size.height / 4.9,
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/images/logo.jpg"),
                      )),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 20,
                      top: MediaQuery.of(context).size.height / 2.8,
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 35),
                      )),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.3,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Remember me"),
                                Checkbox(
                                  value: isChick,
                                  onChanged: (value) {
                                    isChick = !isChick;
                                    setState(() {});
                                  },
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordScreen(),
                                          ));
                                    },
                                    child: Text("ForgetPassword"))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MyElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      HomeCubit.get(context)
                                          .userSigneIn(
                                              mail: mailController.text,
                                              password: passwrodController.text)
                                          .then((value) {
                                        if (isChick) {
                                          print("isChick");
                                          SharedPreference.saveData(
                                              Key: "mail",
                                              value: mailController.text);
                                          SharedPreference.saveData(
                                              Key: "password",
                                              value: passwrodController.text);
                                        }
                                      });
                                    }
                                  },
                                  text: "Log In",
                                  formKey: formKey,
                                ),
                                MyElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen(),
                                        ));
                                  },
                                  text: "Register",
                                  formKey: formKey,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                MyDivider(),
                                Text("Or"),
                                MyDivider(),
                              ],
                            ),
                            Container(
                              height: 60,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await HomeCubit.get(context)
                                        .signInWithGoogle();
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      )),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                        Colors.white,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Image(
                                        image: AssetImage(
                                            "assets/images/google.png"),
                                        width: 30,
                                        // height: 50,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Sign Up With Google",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  )),
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

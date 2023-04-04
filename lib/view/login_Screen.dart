import 'package:flutter/material.dart';
import 'package:netwrok/Widget/my_divider.dart';
import 'package:netwrok/Widget/register_screen/my_elevated_button.dart';
import 'package:netwrok/Widget/register_screen/my_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var mailController = TextEditingController();
  var passwrodController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(100))),
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
                  top: MediaQuery.of(context).size.height / 2.4,
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 35),
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
                            text: "Log In",
                            formKey: formKey,
                            mailController: mailController,
                            passwrodController: passwrodController),
                        SizedBox(
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
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          )),
                                  backgroundColor:const MaterialStatePropertyAll(
                                    Colors.white,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:const [
                                  Image(
                                    image: AssetImage("assets/images/google.png"),
                                    width: 30,
                                    // height: 50,
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Sign Up With Google",style: TextStyle(color: Colors.black),)
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
  }
}

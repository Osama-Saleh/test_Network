// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/Widget/register_screen/my_elevated_button.dart';
import 'package:netwrok/Widget/register_screen/my_text_form_field.dart';
import 'package:netwrok/constaint/constant.dart';
import 'package:netwrok/view/login_Screen.dart';

class SettignScreen extends StatelessWidget {
  SettignScreen({super.key});
  var changeNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    var model = HomeCubit.get(context).userModel;
    var formKey = GlobalKey<FormState>();
    print(
        'rad ${HomeCubit.get(context).userModel!.profileImage == null || HomeCubit.get(context).userModel!.profileImage!.isEmpty}');
    print("rad ${HomeCubit.get(context).userModel!.name}");
    // nameController.text = model!.name!;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is SignOutState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: (HomeCubit.get(context)
                                          .userModel!
                                          .profileImage ==
                                      null ||
                                  HomeCubit.get(context)
                                      .userModel!
                                      .profileImage!
                                      .isEmpty)
                              ? AssetImage("assets/images/logo.jpg")
                              : NetworkImage("${cubit.userModel!.profileImage}")
                                  as ImageProvider,
                        ),
                        const CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt),
                        ),
                        Positioned(
                          right: 3,
                          bottom: 3,
                          child: InkWell(
                            onTap: () {
                              HomeCubit.get(context).getProfileImage();
                              print("Change");
                              print(
                                  "${HomeCubit.get(context).userModel!.name}");
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.amber,
                              child: Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            // color: Colors.red,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            // color: Colors.amber,
                            child: Text(
                              textAlign: TextAlign.center,
                              "${HomeCubit.get(context).userModel!.name}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                            minWidth: 0,
                            height: 0,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Container(
                                  height: 300,
                                  child: Form(
                                    key: formKey,
                                    child: AlertDialog(
                                      title: TextFormField(
                                        controller: changeNameController,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Faild Input";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: "text",
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0)),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 0, 17, 31),
                                                  )),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            // borderSide: BorderSide.none,
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0)),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    strokeAlign: 20,
                                                    color: Color.fromARGB(
                                                        255, 0, 17, 31),
                                                  )),
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            MyElevatedButton(
                                              text: "Cancel",
                                              backgroundColor: Colors.red,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MyElevatedButton(
                                              text: "Update",
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit
                                                      .updateUserData(
                                                          name:
                                                              changeNameController
                                                                  .text)
                                                      .then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Email :${HomeCubit.get(context).userModel!.mail}")
                        ],
                      ),
                    ),
                    MyElevatedButton(
                      text: "Logout",
                      onPressed: () {
                        cubit.signOut();
                        print(Constant.uid);
                        print("SingOut");
                      },
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

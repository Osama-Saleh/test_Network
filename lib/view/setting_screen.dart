import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';

class SettignScreen extends StatelessWidget {
  SettignScreen({super.key});
  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    var model = HomeCubit.get(context).userModel;
    // nameController.text = model!.name!;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
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
                          backgroundImage: 
                          cubit.userModel!.profileImage == null || cubit.userModel!.profileImage!.isEmpty
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
                    Text(
                      "${HomeCubit.get(context).userModel!.name}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

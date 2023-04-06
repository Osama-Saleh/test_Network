// ignore_for_file: await_only_futures, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/constaint/constant.dart';
import 'package:netwrok/network/http_helper.dart';
import 'package:netwrok/storage/shared.dart';
import 'package:netwrok/view/button_app_bar.dart';
import 'package:netwrok/view/register_screen.dart';
import 'package:netwrok/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DioHelper.init();
  await SharedPreference.initialSharedPreference();
   Constant.uid = await SharedPreference.getDataSt(key: "uid");

print("uid : ${Constant.uid}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getUserDate()..getProducts(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: 
              // MyButtonAppBarScreen()
              RegisterScreen()
              // HomeScreen(),
              // const  SplashScreen(),
              );
        },
      ),
    );
  }
}

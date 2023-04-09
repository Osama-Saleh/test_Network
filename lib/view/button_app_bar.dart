// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:netwrok/Cubit/home_cubit.dart';

class MyButtonAppBarScreen extends StatefulWidget {
  const MyButtonAppBarScreen({super.key});

  @override
  State<MyButtonAppBarScreen> createState() => _MyButtonAppBarScreenState();
}

class _MyButtonAppBarScreenState extends State<MyButtonAppBarScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return Scaffold(
      body: cubit.screens[index],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
            // return cubit.changeBottomNavigationBarItem(index);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: "Shopping"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }
}

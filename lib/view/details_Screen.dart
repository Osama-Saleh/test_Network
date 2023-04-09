import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';

class DetailsScreen extends StatelessWidget {
  int? index;
  DetailsScreen({super.key,this.index});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Image(
                  image: NetworkImage(
                      "${HomeCubit.get(context).product![index!].image}"),fit: BoxFit.fill,
                      height: 300,
                      width: double.infinity,
                      )
            ],
          ),
        );
      },
    );
  }
}

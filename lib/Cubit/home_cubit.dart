// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/model/product_model.dart';
import 'package:netwrok/network/http_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitState());
  static HomeCubit get(context) => BlocProvider.of(context);

  void userRegisted({required String mail, required String password}) {
    emit(RegisterLoadingState());
    print("RegisterLoadingState");
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: mail,
      password: password,
    )
        .then((value) {
      print("token : ${value.user!.uid}");
      emit(RegisterSuccessState());
      print("RegisterSuccessState");
    }).catchError((onError) {
      emit(RegisterErrorState());
      print("RegisterErrorState : $onError");
    });
  }

  List<ProductModel>? product;
  void getProducts() async {
    emit(ProductLoadingState());
    print("ProductLoadingState");
    try {
      final value = await DioHelper.getData();
      print("value.data ${value.data}");

      var temp = value.data
          .map<ProductModel>(
            (item) => ProductModel.fromJson(item),
          )
          .toList();
      product = temp;
      print("product : ${product!.length}");
      print("product : ${product![0].id}");

      emit(ProductSuccsessgState());
      print("ProductSuccsessgState");
    } catch (error) {
      emit(ProductErrorState());
      print("ProductErrorState $error");
    }
  }
}

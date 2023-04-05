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

  //*===================================================//
  //*=================Register user=====================//
  //*====================================== ============//
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

  //*==================================================//
  //*=================  Sign In  =====================//
  //*================================================//
  Future<void> userSigneIn(
      {required String mail, required String password}) async {
    emit(SigninLoadingState());
    print("SigninLoadingState");
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: password)
        .then((value) {
      print("Uid : ${value.user!.uid}");
      emit(SigninSuccessState(token: value.user!.uid));
      print("SigninSuccessState");
    }).catchError((onError) {
      emit(SigninErrorState());
      print("SigninErrorState $onError");
    });
  }

  //*==================================================//
  //*=================  forget Password  =====================//
  //*================================================//
  Future<void> resetPassword({required String mail}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: mail)
        .then((value) {
      print("reset Pass");
    }).catchError((onError) {});
  }

  //*=====================================================//
  //*=================git products from API===============//
  //*=====================================================//
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

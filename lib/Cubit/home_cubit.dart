// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netwrok/Cubit/home_cubit_state.dart';
import 'package:netwrok/constaint/constant.dart';
import 'package:netwrok/model/product_model.dart';
import 'package:netwrok/model/user_model.dart';
import 'package:netwrok/network/http_helper.dart';
import 'package:netwrok/storage/shared.dart';
import 'package:netwrok/view/Home_Screen.dart';
import 'package:netwrok/view/setting_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitState());
  static HomeCubit get(context) => BlocProvider.of(context);

  //*===================================================//
  //*=================Register user=====================//
  //*====================================== ============//
  void userRegisted(
      {required String name, required String mail, required String password}) {
    emit(RegisterLoadingState());
    print("RegisterLoadingState");
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: mail,
      password: password,
    )
        .then((value) {
      print("token : ${value.user!.uid}");
      createUserDate(name: name, emial: mail, id: value.user!.uid);
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
  //*=================  sign Out  =====================//
  //*================================================//

  void signOut() {
    FirebaseAuth.instance.signOut();
    SharedPreference.removeDate(key: "uid");
    emit(SignOutState());
  }

  //*==================================================//
  //*=================  forget Password  =============//
  //*================================================//
  Future<void> resetPassword({required String mail}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: mail)
        .then((value) {
      print("reset Pass");
    }).catchError((onError) {});
  }

  //*===============================================//
  //*============= sign up with google =============//
  //*===============================================//
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().then((value) {
      print("GoogleSignInAccount${value!.id}");
    });

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  List<Widget> screens = [HomeScreen(), SettignScreen()];
  int currentIndex = 0;
  void changeBottomNavigationBarItem(int index) {
    currentIndex = index;
    print("currentIndex : $currentIndex");
    emit(ChangeBottomNavBarState());
  }

  //*=====================================================//
  //*===================== Create user ===================//
  //*=====================================================//
  void createUserDate({
    String? name,
    String? emial,
    String? id,
  }) {
    emit(CreatUserLoadingState());
    print("CreatUserLoadingState");
    UserModel userModel = UserModel(name: name, mail: emial, id: id);
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userModel.toMap())
        .then((value) {
      emit(CreatUserSuccessState());
      print("CreatUserSuccessState");
    }).catchError((onError) {
      emit(CreatUserErrorState());
      print("CreatUserErrorState");
    });
  }

  //*=====================================================//
  //*=================== Get User Date ==================//
  //*====================================================//

  UserModel? userModel;
  Future getUserDate() async {
    emit(GetUserDateLoadingState());
    print("GetUserDateLoadingState");
    final value = await FirebaseFirestore.instance
        .collection("users")
        .doc(Constant.uid)
        .get();
    userModel = UserModel.fromJson(value.data()!);
    print("Data of users  : ${value.data()!}");
    print("Uid cubit : ${Constant.uid}");
    emit(GetUserDateSuccessState());
    print("GetUserDateSuccessState");
    //     .then((value) {
    //   print(value.data());
    //   userModel = UserModel.fromJson(value.data()!);
    //   emit(GetUserDateSuccessState());
    //   print("GetUserDateSuccessState");
    // }).catchError((onError) {
    //   emit(GetUserDateErrorState());
    //   print("GetUserDateErrorState $onError");
    // });
  }

  Future updateUserData({
    String? name,
    String? profileImage,
    String? id,
    String? mail,
  }) async {
    emit(UpdateUserDateLoadingState());
    print("UpdateUserDateLoadingState");

    UserModel model = UserModel(
      name: name ?? userModel!.name,
      profileImage: profileImage ?? userModel!.profileImage ?? " ",
      id: Constant.uid,
      mail: userModel!.mail,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(Constant.uid)
        .update(model.toMap())
        .then((value) {
      getUserDate();
      emit(UpdateUserDateSuccessState());
      print("UpdateUserDateSuccessState");
    }).catchError((onError) {
      emit(UpdateUserDateErrorState());

      print("UpdateUserDateErrorState");
    });
  }

  //*=====================================================//
  //*============ Get image from Device =================//
  //*===================================================//
  File? profileImage = null;
  ImagePicker profilepicker = ImagePicker();

  Future getProfileImage({
    @required String? name,

    // @required String? phone,
  }) async {
    emit(ProfileImageLoadingState());
    // print("ProfileImageLoadingState");
    final imagefile =
        await profilepicker.pickImage(source: ImageSource.gallery);

    if (imagefile != null) {
      profileImage = File(imagefile.path);
      // print("image Path is : ${profileImage}");
      uploadProfileImage(name: name);
      emit(ProfileImageSuccessState());
    } else {
      // print("Not Image Selected");
      emit(ProfileImageErrorState());
    }
  }

  String? profileImageurl;
  Future<void> uploadProfileImage({
    @required String? name,

    // @required String? phone,
  }) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("images/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      // print("${value}");
      value.ref.getDownloadURL().then((value) {
        // print("getDownloadURLSuccess");

        // print(value);
        updateUserData(name: name, profileImage: value);
        // profileImageurl = value;
        // print(value);
      }).catchError((Error) {
        // print("getDownloadURLError ${Error}");
      });
    }).catchError((Error) {
      // print("uploadProfileImage ${Error}");
    });
  }

  //*=====================================================//
  //*=================git products from API===============//
  //*=====================================================//
  List<ProductModel>? product;
  Map<int, bool>? isFavorite = {};
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
      temp.forEach((element) {
        isFavorite!.addAll({element.id-1: false});
      });
      // temp.forEach((element) {
      //   isFavorite!.addAll({element.id : false});
      //   print("element : ${element.id}");
      // });
      print("product : ${product![0]}");
      print("product : ${product![0].id}");

      emit(ProductSuccsessgState());
      print("ProductSuccsessgState");
    } catch (error) {
      emit(ProductErrorState());
      print("ProductErrorState $error");
    }
  }

  //*=====================================================//
//*============= change Favorites items  ===============//
//*=====================================================//
  List? myFavorites=[];
  void changeFavoriteIcon({int? index}) {
    // myFavorites = [];
    print("is favorites for index $index ${isFavorite![index]}");
    if (isFavorite![index] == false) {
      isFavorite![index!] = true;
      myFavorites!.add(isFavorite![index]);
      print(isFavorite![index]);
      print("----------------------------------");
      emit(ChangeFavoritesIcon());
    } else if (isFavorite![index] == true) {
      
      myFavorites!.removeWhere((index) =>isFavorite![index!] == true );
      isFavorite![index!] = false;
      print(isFavorite![index]);
      print("----------------------------------");
      emit(ChangeFavoritesIcon());
    }
    print("myFavo $myFavorites");
  }
}

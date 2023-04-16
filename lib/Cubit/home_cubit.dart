// ignore_for_file: avoid_print, non_constant_identifier_names, avoid_types_as_parameter_names, unnecessary_brace_in_string_interps, prefer_is_empty

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
import 'package:netwrok/view/favorites_items.dart';
import 'package:netwrok/view/setting_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

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

  List<Widget> screens = [
    HomeScreen(),
    FavoritesItemsScreen(),
    SettignScreen()
  ];
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
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      print("Data of users  : ${value.data()!}");
      print("Uid cubit : ${Constant.uid}");
      emit(GetUserDateSuccessState());
      print("GetUserDateSuccessState");
    }).catchError((onError) {
      print("GetUserDateErrorState");
      emit(GetUserDateErrorState());
    });

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
      value.ref.getDownloadURL().then((value) {
        updateUserData(name: name, profileImage: value);
      }).catchError((Error) {
        print("getDownloadURLError ${Error}");
      });
    }).catchError((Error) {
      print("uploadProfileImage ${Error}");
    });
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
//*============= Add Favorites items  ===============//
//*=====================================================//

  // List<ProductModel>? favProduct = [];
  Future changeFavoriteIcon({required ProductModel product}) async {
    // product.isFavorite = !product.isFavorite;

    print(product.isFavorite);
    if (product.isFavorite == 0) {
      // favProduct!.add(product);
      product.isFavorite = 1;
      insertData(product);
      print("ChangeFavoritesIcon");
      emit(ChangeFavoritesIcon());
    } else {
      product.isFavorite = 0;
      deleteFavoriteItem(product);
      emit(ChangeFavoritesIcon());
      print("ChangeFavoritesIcon");
      // favProduct!.removeWhere((element) {
      //   return element.id == product.id;
      // });
    }
    emit(ChangeFavoritesIcon());
    // print('length of fav => ${favProduct!.length}');
  }

  Database? database;
  Future createDataBase() async {
    // path is name on table => 'todo.db'
    database = await openDatabase(
      "favorite.db",
      version: 1,
      onCreate: (db, version) async {
        print("Created DataBase");
        await db
            .execute(
                'CREATE TABLE favorites (idd INTEGER PRIMARY KEY,id  INTEGER,title TEXT,price REAL,description TEXT, category TEXT,image TEXT,isFavorite INTEGER)')
            .then((value) {
          print("Created Table");
        }).catchError((error) {
          emit(CreateDataBaseErrorState());
          print("CreateDataBaseErrorState");
          print("database error: " + error);
        });
      },
      onOpen: (db) async {
        // await getDataBase(db);
        getFavorite(db: db);
        emit(CreateDataBaseSuccessState());
        print("DataBase Is Opened");
      },
    );
    // emit(CreateDataBaseSuccessState());
  }

  //* Insert data
  var nresult;
  Future insertData(ProductModel productModel, {Database? db}) async {
    emit(InsertDataLoadingState());
    print("InsertDataLoadingState");
    nresult = await database!.insert("favorites", productModel.toJson());
    getFavorite(db: db ?? database);
    print("InsertDataSuccessState");
    emit(InsertDataSuccessState());
  }

  List? getFinalresult;
  Future<ProductModel?> getFavorite({Database? db}) async {
    // var sql = "SELECT * FORM favorites WHERE isFavorite = $isFavorite";
    var sql = "SELECT * FROM favorites";
    getFinalresult = await db!.rawQuery(sql);
    print("Favorite data : ${getFinalresult}");
    print("result length : ${getFinalresult!.length}");
    // print("result : ${getFinalresult![nresult - 1]}");
    // print("result : ${getFinalresult![nresult - 1]["title"]}");
    if (getFinalresult!.length == 0) {
      return null;
    }
    emit(GetFavoriteDataSuccessState());
    return ProductModel.fromJson(getFinalresult!.first);
  }

//! Why dont delete item when useing isFavorite
  Future deleteFavoriteItem(ProductModel productModel, {Database? db}) async {
    emit(DeleteFavoriteItemLoadingState());
    print("DeleteFavoriteItemLoadinState");
    final value = await database!.delete("favorites",
        where: "id = ?", whereArgs: [productModel.id]);
    // final value = await database!.delete("favorites",
    //     where: "isFavorite = ?", whereArgs: [productModel.isFavorite]);
    getFavorite(db: db ?? database);
    print("delet value $value");
    print("DeleteFavoriteItemSuccessState");
    emit(DeleteFavoriteItemSuccessState());
  }
}


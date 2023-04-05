// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeStates {}

class InitState extends HomeStates {}

class ProductLoadingState extends HomeStates {}

class ProductSuccsessgState extends HomeStates {}

class ProductErrorState extends HomeStates {}

class RegisterLoadingState extends HomeStates {}

class RegisterSuccessState extends HomeStates {}

class RegisterErrorState extends HomeStates {}

class SigninLoadingState extends HomeStates {}

class SigninSuccessState extends HomeStates {
  String? token;
  SigninSuccessState({
    this.token,
  });
}

class SigninErrorState extends HomeStates {}

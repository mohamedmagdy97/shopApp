import 'package:shop_app/models/login_model.dart';

abstract class AppRegisterStates {}

class AppRegisterInitialState extends AppRegisterStates {}

class AppRegisterLoadingState extends AppRegisterStates {}

class AppRegisterSuccessState extends AppRegisterStates {
  final LoginModel loginModel;

  AppRegisterSuccessState(this.loginModel);
}

class AppRegisterErrorState extends AppRegisterStates {
  final String error;

  AppRegisterErrorState(this.error);
}

class AppRegisterPassVisibilityState extends AppRegisterStates {}

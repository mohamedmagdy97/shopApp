import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/logout_model.dart';

abstract class HomeStates {}

class InitialHomeState extends HomeStates {}

class ChangeBottomNavHomeState extends HomeStates {}

class LoadingHomeDataState extends HomeStates {}

class SuccessHomeDataState extends HomeStates {}

class ErrorHomeDataState extends HomeStates {}

class SuccessCategoriesDataState extends HomeStates {}

class ErrorCategoriesDataState extends HomeStates {}

class SuccessFavoritesDataState extends HomeStates {}

class SuccessChangeFavoritesDataState extends HomeStates {
  final ChangeFavoritesModel model;

  SuccessChangeFavoritesDataState(this.model);
}

class ErrorChangeFavoritesDataState extends HomeStates {}

class LoadingGetFavoritesDataState extends HomeStates {}

class SuccessGetFavoritesDataState extends HomeStates {}

class ErrorGetFavoritesDataState extends HomeStates {}

class LoadingUserDataState extends HomeStates {}

class SuccessUserDataState extends HomeStates {
  final LoginModel loginModel;

  SuccessUserDataState(this.loginModel);
}

class ErrorUserDataState extends HomeStates {}

class LoadingUpdateUserDataState extends HomeStates {}

class SuccessUpdateUserDataState extends HomeStates {
  final LoginModel loginModel;

  SuccessUpdateUserDataState(this.loginModel);
}

class ErrorUpdateUserDataState extends HomeStates {
  final LoginModel loginModel;

  ErrorUpdateUserDataState(this.loginModel);
}

class ChangeEditUserDataState extends HomeStates {}

class LoadingLogoutUserDataState extends HomeStates {}

class SuccessLogoutUserDataState extends HomeStates {
  final LogoutModel logoutModel;

  SuccessLogoutUserDataState(this.logoutModel);
}

class ErrorLogoutUserDataState extends HomeStates {}

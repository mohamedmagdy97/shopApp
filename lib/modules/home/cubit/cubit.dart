import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/logout_model.dart';
import 'package:shop_app/modules/home/cubit/screens/categories_screen.dart';
import 'package:shop_app/modules/home/cubit/screens/favorites_screen.dart';
import 'package:shop_app/modules/home/cubit/screens/products_screen.dart';
import 'package:shop_app/modules/home/cubit/screens/profile_screen.dart';
import 'package:shop_app/modules/home/cubit/states.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/components/constants.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;

    emit(ChangeBottomNavHomeState());
  }

  Map<int, bool> favorites = {};
  HomeModel homeModel;

  void getHomeData() {
    emit(LoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      // printFullText(homeModel.data.banners[0].image);
      // print('status : ${homeModel.status}');
      // print('image : ${homeModel.data.banners[0]['image']}');

      homeModel.data.products.forEach((element) {
        favorites.addAll({element['id']: element['in_favorites']});
      });

      // print('Favorites : ${favorites.toString()}');
      emit(SuccessHomeDataState());
    }).catchError((error) {
      print('Error : ' + error.toString());
      emit(ErrorHomeDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategoriesData() {
    emit(LoadingHomeDataState());
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      // print('Category Data : ${categoriesModel.data.data}');
      emit(SuccessCategoriesDataState());
    }).catchError((error) {
      print('Error : ' + error.toString());
      emit(ErrorCategoriesDataState());
    });
  }

  ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];

    emit(SuccessFavoritesDataState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      // print(value.data);
      if (!(changeFavoritesModel.status)) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavoritesData();
      }

      emit(SuccessChangeFavoritesDataState(changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId];

      emit(ErrorChangeFavoritesDataState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavoritesData() {
    emit(LoadingGetFavoritesDataState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      // printFullText('Fav. Data : ${value.data.toString()}');

      emit(SuccessGetFavoritesDataState());
    }).catchError((error) {
      print('Error fav. : ${error.toString()}');
      emit(SuccessGetFavoritesDataState());
    });
  }

  LoginModel userModel;

  String name ='' ,phone ='',email='';
  void getUserData() {
    emit(LoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);

      printFullText('User Data : ${value.data.toString()}');

      name = userModel.data.name;
      email = userModel.data.email;
      phone = userModel.data.phone;

      emit(SuccessUserDataState(userModel));
    }).catchError((error) {
      print('Error User. : ${error.toString()}');
      emit(ErrorUserDataState());
    });
  }

  bool editProfile = false;

  void changeEditProfile() {
    editProfile = !editProfile;
    emit(ChangeEditUserDataState());
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(LoadingUpdateUserDataState());

    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) {
      userModel = LoginModel.fromJson(value.data);

      printFullText('Updated User Data : ${value.data.toString()}');

      emit(SuccessUpdateUserDataState(userModel));
    }).catchError((error) {
      print('Error Updated User. : ${error.toString()}');
      emit(ErrorUpdateUserDataState(userModel));
    });
  }


  LogoutModel logoutModel ;
  void logoutUser(token) {
    emit(LoadingLogoutUserDataState());

    DioHelper.postData(
      url: LOGOUT,
      data: {
        'token': token,
      },
      token: token,
    ).then((value) {
      logoutModel = LogoutModel.fromJson(value.data);

      emit(SuccessLogoutUserDataState(logoutModel));
    }).catchError((error) {
      emit(ErrorLogoutUserDataState());
    });
  }
}

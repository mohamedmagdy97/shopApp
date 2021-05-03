import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'file:///C:/Users/Magdy/AndroidStudioProjects/shop_app/lib/modules/search/search_screen.dart';
import 'package:shop_app/modules/home/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/colors.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is SuccessLogoutUserDataState) {
          if (state.logoutModel.status) {
            CacheHelper.removeData(key: 'token').then((value) {
              token = '';
              navigateAndFinish(context, LoginScreen());
              cubit.currentIndex = 0;

              cubit.name = '';
              cubit.email = '';
              cubit.phone = '';
              defaultToast(
                msg: state.logoutModel.message,
                state: ToastStates.SUCCESS,
              );
            });
          } else {
            defaultToast(
              msg: state.logoutModel.message,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) => state is LoadingLogoutUserDataState
          ? Scaffold(body: buildCircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                actionsIconTheme: IconThemeData(color: defaultColor),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      navigateTo(context, SearchScreen());
                    },
                    tooltip: 'Search',
                  ),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      HomeCubit.get(context).logoutUser(token);
                    },
                    tooltip: 'Logout',
                  ),
                ],
                title: Text(
                  'Shopping',
                  style: TextStyle(color: defaultColor),
                ),
              ),
              body: cubit.bottomScreens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeBottomNavBar(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.apps),
                    label: 'Categories',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
    );
  }
}

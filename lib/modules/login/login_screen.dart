import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/home_layout.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);

    return BlocProvider(
      create: (BuildContext context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginStates>(
        listener: (context, state) {
          if (state is AppLoginSuccessState) {
            if (state.loginModel.status) {
              CacheHelper.saveDate(
                      key: 'token', value: state.loginModel.data.token)
                  .then((value) {
                token = state.loginModel.data.token;

                cubit.name = state.loginModel.data.name;
                cubit.email = state.loginModel.data.email;
                cubit.phone = state.loginModel.data.phone;

                navigateAndFinish(context, HomeLayout());

                defaultToast(
                  msg: state.loginModel.message,
                  state: ToastStates.SUCCESS,
                );
              });
            } else {
              defaultToast(
                msg: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'Login now to browse our app',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      defaultFormField(
                        controller: emailController,
                        validator: (String val) {
                          if (val.isEmpty) {
                            return 'Please enter your email address';
                          }
                        },
                        type: TextInputType.emailAddress,
                        pIcon: Icon(Icons.email_outlined),
                        label: 'Email Address',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        isPassword: AppLoginCubit.get(context).isPassword,
                        controller: passwordController,
                        onSubmit: (val) {
                          if (formKey.currentState.validate()) {
                            AppLoginCubit.get(context).userLogin(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        validator: (String val) {
                          if (val.isEmpty) {
                            return 'Please enter your password';
                          }
                        },
                        type: TextInputType.visiblePassword,
                        pIcon: Icon(Icons.lock_open),
                        sIcon: IconButton(
                          icon: Icon(AppLoginCubit.get(context).suffix),
                          onPressed: () {
                            AppLoginCubit.get(context).changePassVisibility();
                          },
                        ),
                        label: 'Password',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: state is! AppLoginLoadingState,
                        builder: (context) => defaultButton(
                          text: 'LOGIN',
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              AppLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) => buildCircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          defaultTextButton(
                              text: 'register',
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

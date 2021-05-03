import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/home_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppRegisterCubit(),
      child: BlocConsumer<AppRegisterCubit, AppRegisterStates>(
        listener: (context, state) {
          if (state is AppRegisterSuccessState) {
            if (state.loginModel.status) {
              CacheHelper.saveDate(
                      key: 'token', value: state.loginModel.data.token)
                  .then((value) {

                token = state.loginModel.data.token;
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up!',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'SignUp now to browse our app',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      ///name
                      defaultFormField(
                        controller: nameController,
                        validator: (String val) {
                          if (val.isEmpty) {
                            return 'Please enter your name';
                          }
                        },
                        type: TextInputType.text,
                        pIcon: Icon(Icons.title),
                        label: 'Name',
                      ),

                      ///email
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: emailController,
                        validator: (String val) {
                          if (val.isEmpty || !val.contains('@')) {
                            return 'Please enter valid email address';
                          }
                        },
                        type: TextInputType.emailAddress,
                        pIcon: Icon(Icons.email_outlined),
                        label: 'Email Address',
                      ),

                      /// phone
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        validator: (String val) {
                          if (val.isEmpty || val.length != 11) {
                            return 'Please enter valid phone number';
                          }
                        },
                        type: TextInputType.phone,
                        pIcon: Icon(Icons.phone),
                        label: 'Phone number',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        isPassword: AppRegisterCubit.get(context).isPassword,
                        controller: passwordController,
                        onSubmit: (val) {},
                        validator: (String val) {
                          if (val.isEmpty || val.length < 6) {
                            return 'Please password must at least 6 digit';
                          }
                        },
                        type: TextInputType.visiblePassword,
                        pIcon: Icon(Icons.lock_open),
                        sIcon: IconButton(
                          icon: Icon(AppRegisterCubit.get(context).suffix),
                          onPressed: () {
                            AppRegisterCubit.get(context)
                                .changePassVisibility();
                          },
                        ),
                        label: 'Password',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: state is! AppRegisterLoadingState,
                        builder: (context) => defaultButton(
                          text: 'REGISTER',
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              AppRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text);
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
                          Text('Have an account?'),
                          defaultTextButton(
                              text: 'LOGIN',
                              onPressed: () {
                                navigateAndFinish(context, LoginScreen());
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

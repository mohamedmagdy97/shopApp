import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/home/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is SuccessUpdateUserDataState) {
          if (state.loginModel.status) {
            defaultToast(
              msg: state.loginModel.message,
              state: ToastStates.SUCCESS,
            );
          } else {
            defaultToast(
              msg: state.loginModel.message,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        nameController.text = cubit.name;
        emailController.text = cubit.email;
        phoneController.text = cubit.phone;
        return ConditionalBuilder(
          condition: cubit.userModel != null,
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/icons/user.jpg'),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              Colors.blueGrey[100].withOpacity(0.2),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: defaultColor,
                              size: 30,
                            ),
                            onPressed: () {
                              HomeCubit.get(context).changeEditProfile();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (state is LoadingUpdateUserDataState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: nameController,
                      validator: (String val) {
                        if (val.isEmpty) {
                          return 'Fill it';
                        }
                      },
                      enabled: HomeCubit.get(context).editProfile,
                      type: TextInputType.text,
                      pIcon: Icon(Icons.title),
                      label: 'Name',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: emailController,
                      validator: (String val) {
                        if (val.isEmpty) {
                          return 'Fill it';
                        }
                      },
                      enabled: HomeCubit.get(context).editProfile,
                      type: TextInputType.emailAddress,
                      pIcon: Icon(Icons.email_outlined),
                      label: 'Email Address',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      enabled: HomeCubit.get(context).editProfile,
                      validator: (String val) {
                        if (val.isEmpty) {
                          return 'Fill it';
                        }
                      },
                      type: TextInputType.phone,
                      pIcon: Icon(Icons.phone),
                      label: 'Phone',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* defaultButton(
                      text: 'EDIT',
                      onPressed: () {
                        HomeCubit.get(context).changeEditProfile();
                      },
                    ),*/
                    SizedBox(
                      height: 10,
                    ),
                    defaultButton(
                      text: 'UPDATE',
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          HomeCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                          HomeCubit.get(context).name = nameController.text;
                          HomeCubit.get(context).email = emailController.text;
                          HomeCubit.get(context).phone = phoneController.text;

                          HomeCubit.get(context).changeEditProfile();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => buildCircularProgressIndicator(),
        );
      },
    );
  }
}

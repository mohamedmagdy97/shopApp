import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/home/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (context, state) => ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Image(
                    image: NetworkImage(HomeCubit.get(context)
                        .categoriesModel
                        .data
                        .data[index]
                        .image),
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    HomeCubit.get(context)
                        .categoriesModel
                        .data
                        .data[index]
                        .name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return myDivider(context);
          },
          itemCount: HomeCubit.get(context).categoriesModel.data.data.length),
      listener: (context, state) {},
    );
  }
}

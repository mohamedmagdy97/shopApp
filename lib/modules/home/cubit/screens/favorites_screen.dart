import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/home/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! LoadingGetFavoritesDataState,
          fallback: (context) => buildCircularProgressIndicator(),
          builder: (context) => HomeCubit.get(context).favoritesModel.data.data.isEmpty
              ? Center(
                  child: Text(
                    'You have\'t favorite product!',
                    style: TextStyle(
                      fontSize: 20,
                      color: defaultColor,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildListProduct(
                        HomeCubit.get(context).favoritesModel.data.data[index].product,
                        context,);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                  itemCount:
                      HomeCubit.get(context).favoritesModel.data.data.length),
        );
      },
      listener: (context, state) {},
    );
  }

}

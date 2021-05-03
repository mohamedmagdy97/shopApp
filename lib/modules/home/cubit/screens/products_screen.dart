import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/home/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).homeModel != null &&
              HomeCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              HomeCubit.get(context).homeModel,
              HomeCubit.get(context).categoriesModel,
              context),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      listener: (context, state) {
        if( state is SuccessChangeFavoritesDataState){
          if(!state.model.status){
            defaultToast(msg: HomeCubit.get(context).changeFavoritesModel.message, state: ToastStates.ERROR);
          }else{
            defaultToast(msg: HomeCubit.get(context).changeFavoritesModel.message, state: ToastStates.DEFAULT);

          }
        }
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e['image']}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                viewportFraction: 1.0,
                initialPage: 0,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(seconds: 1),
                enableInfiniteScroll: true,
                reverse: false,
                scrollDirection: Axis.horizontal,
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(categoriesModel.data.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 5,
                      ),
                      itemCount: categoriesModel.data.data.length,
                    ),
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    color: Colors.grey[100],
                    child: gridView(model, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  GridView gridView(HomeModel model, context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 1 / 1.45,
      children: List.generate(
        model.data.products.length,
        (index) => buildGridProduct(model, index, context),
      ),
    );
  }

  Stack buildCategoryItem(DataModel model) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image(
            image: NetworkImage('${model.image}'),
            width: 120,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black38,
          ),
          alignment: Alignment.center,
          width: 120,
          height: 80,
          child: Text(
            model.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    );
  }

  Widget buildGridProduct(HomeModel model, int index, context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.data.products[index]['image']),
                    width: double.infinity,
                    height: 180,
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: CircleAvatar(
                      foregroundColor: Colors.black,
                      radius: 15,
                      backgroundColor: HomeCubit.get(context)
                              .favorites[model.data.products[index]['id']]
                          ? defaultColor
                          : Colors.grey,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            HomeCubit.get(context).changeFavorites(
                                model.data.products[index]['id']);

                            // defaultToast(
                            //     msg: HomeCubit.get(context)
                            //         .favoritesModel.message.toString(),
                            //     state: ToastStates.DEFAULT);
                          }),
                    ),
                  ),
                  if (model.data.products[index]['discount'] != 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.red,
                      child: Text(
                        'SALE',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                ],
              ),
              Text(
                model.data.products[index]['name'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1.3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${model.data.products[index]['price']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: defaultColor),
                  ),
                  if (model.data.products[index]['discount'] != 0)
                    Text(
                      '\$${model.data.products[index]['old_price']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridView2(HomeModel model) {
    /*  return GridView.count(
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childAspectRatio: 1 / 1.45,
      children: List.generate(
        model.data.products.length,
            (index) => buildGridProduct(model, index),
      ),
    );*/
    return StaggeredGridView.countBuilder(
      itemCount: model.data.products.length,
      crossAxisCount: 4,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildGridProduct2(model, index);
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 80,
      crossAxisSpacing: 1,
    );
  }

  Widget buildGridProduct2(HomeModel model, int index) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image(
                      image: NetworkImage(model.data.products[index]['image']),
                      width: double.infinity,
                      height: 180,
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: defaultColor,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: () {}),
                      ),
                    ),
                    /*  if (model.data.products[index]['discount'] != 0)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.red,
                        child: Text(
                          'SALE',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    */
                  ],
                ),
              ],
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.data.products[index]['name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${model.data.products[index]['price']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: defaultColor),
                    ),
                    if (model.data.products[index]['discount'] != 0)
                      Text(
                        '\$${model.data.products[index]['old_price']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

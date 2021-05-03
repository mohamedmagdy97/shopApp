import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required Function validator,
  Function onTap,
  @required TextInputType type,
  @required Widget pIcon,
  Widget sIcon,
  Function onSubmit,
  Function onChange,
  bool enabled = true,
  bool isPassword = false,
  @required String label,
}) =>
    TextFormField(
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      controller: controller,
      validator: validator,
      keyboardType: type,
      obscureText: isPassword,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: pIcon,
        labelText: label,
        suffixIcon: sIcon,
        enabled: enabled,
        border: OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  @required String text,
  @required Function onPressed,
  bool isUpperCase = true,
  double radius = 3,
}) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      color: defaultColor,
      textColor: Colors.white,
      child: Text(isUpperCase ? text.toUpperCase() : text),
    ),
  );
}

var color;
enum ToastStates { SUCCESS, ERROR, WARNING, DEFAULT }

Color chooseToastColor(ToastStates states) {
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.DEFAULT:
      color = Colors.deepPurple;
      break;
  }
  return color;
}

void defaultToast({@required String msg, @required ToastStates state}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Widget defaultTextButton(
    {@required String text, @required Function onPressed}) {
  return TextButton(onPressed: onPressed, child: Text(text.toUpperCase()));
}

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

Widget myDivider(context) {
  return Padding(
    padding: EdgeInsetsDirectional.only(start: 10),
    child: Container(
      height: 1.0,
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      width: double.infinity,
    ),
  );
}

Widget buildCircularProgressIndicator() => Center(
      child: CircularProgressIndicator(),
    );

Widget buildListProduct(model, context,{bool isOldPrice = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Card(
      elevation: 2.5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  width: 80,
                  height: 80,
                ),
                if (model.discount != 0 &&isOldPrice)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'SALE',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '\$${model.price}',
                        style: TextStyle(color: defaultColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          '\$${model.oldPrice}',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Spacer(
                        flex: 1,
                      ),
                      CircleAvatar(
                        foregroundColor: Colors.black,
                        radius: 15,
                        backgroundColor:
                            HomeCubit.get(context).favorites[model.id]
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
                              // HomeCubit.get(context).changeFavorites(model.data.products[index]['id']);
                              HomeCubit.get(context).changeFavorites(model.id);
                              if(isOldPrice)
                              defaultToast(
                                msg: 'Deleted Successfully',
                                state: ToastStates.DEFAULT,
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

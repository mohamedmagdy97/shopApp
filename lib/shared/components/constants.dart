import 'package:shop_app/modules/home/cubit/cubit.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token');
  HomeCubit.get(context).currentIndex = 0;
  navigateAndFinish(context, LoginScreen());
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((element) => print(element.group(0)));
}

String token = '';

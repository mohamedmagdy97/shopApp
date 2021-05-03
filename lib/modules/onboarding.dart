import 'package:flutter/material.dart';
import 'package:shop_app/models/boarding_model.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'file:///C:/Users/Magdy/AndroidStudioProjects/shop_app/lib/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardingController = PageController();

  bool isLast = false;

  List<BoardingModel> boardingItems = [
    BoardingModel(
        image: 'assets/icons/onboarding.png',
        title: 'Title Screen 1',
        subTitle: 'subTitle Screen 1'),
    BoardingModel(
        image: 'assets/icons/onboarding.png',
        title: 'Title Screen 2',
        subTitle: 'subTitle Screen 2'),
    BoardingModel(
        image: 'assets/icons/onboarding.png',
        title: 'Title Screen 3',
        subTitle: 'subTitle Screen 3'),
  ];

  void submit() {
    CacheHelper.saveDate(key: 'onBoarding', value: true,);
    navigateAndFinish(context, LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            defaultTextButton(
              text: 'Skip',
              onPressed: () => submit(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (pageCount) {
                    if (pageCount == boardingItems.length - 1) {
                      setState(() => isLast = true);
                    } else {
                      setState(() => isLast = false);
                    }
                  },
                  itemCount: boardingItems.length,
                  physics: BouncingScrollPhysics(),
                  controller: boardingController,
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boardingItems[index]),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      expansionFactor: 4,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 5,
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                    ),
                    controller: boardingController,
                    count: boardingItems.length,
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardingController.nextPage(
                            duration: Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image.asset('${model.image}')),
          Text(
            '${model.title}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${model.subTitle}',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

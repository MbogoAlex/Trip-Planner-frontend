import 'package:get/get.dart';

double screenHeight(x) {
  double screenHeight = Get.context!.height;
  double a = 866.2857142857143 / x;
  double height = screenHeight / a;
  return height;
}

double screenWidth(x) {
  double screenWidth = Get.context!.width;
  double a = 411.42857142857144 / x;
  double width = screenWidth / a;
  return width;
}

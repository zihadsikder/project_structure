import 'package:gat/features/home/presentaion/screens/home_screen.dart';
import 'package:gat/features/profile/presentation/screens/profile_screen.dart';


import 'package:get/get.dart';
import '../../../core/services/Auth_service.dart';

class NavBarController extends GetxController {
  var selectedIndex = 0.obs;

  int get currentIndex => selectedIndex.value;

  List screens = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    AuthService.init();
  }

  void changeIndex(int index) {
    if (selectedIndex.value == index) {
      return;
    }

    selectedIndex.value = index;
  }

  void backToHome() {
    changeIndex(0);
  }
}
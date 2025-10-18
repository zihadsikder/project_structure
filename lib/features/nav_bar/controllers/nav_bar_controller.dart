import 'package:get/get.dart';
import '../../../core/services/Auth_service.dart';
import '../../chat_without_functionality/screens/message_list.dart';
import '../../home/presentaion/screens/home_screen.dart';
import '../../profile/presentation/screens/profile_screen.dart';

class NavBarController extends GetxController {
  var selectedIndex = 0.obs;

  int get currentIndex => selectedIndex.value;

  List screens = [
    HomeScreen(),
    HomeScreen(),
    MessageScreenWF(),
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
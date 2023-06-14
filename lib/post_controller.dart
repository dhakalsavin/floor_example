import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  RxBool connectivityResult = false.obs;

  checkConnectivity() async {
    print("aaaa${connectivityResult}");
    final result = await Connectivity().checkConnectivity();
    return connectivityResult.value = result != ConnectivityResult.none;
  }
}

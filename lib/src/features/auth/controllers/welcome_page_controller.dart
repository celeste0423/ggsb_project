import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WelcomePageController extends GetxController {
  Future<String> getVersionInfo() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}

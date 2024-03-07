import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/event_model.dart';
import 'package:ggsb_project/src/repositories/event_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPageController extends GetxController {
  static EventPageController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<EventModel>> getEventList() async {
    return await EventRepository().getEventList();
  }

  void eventCardButton(String? contentUrl) async {
    Uri uri = Uri.parse(contentUrl ?? ServiceUrls.ggsbInstagram);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openAlertDialog(title: '페이지를 열 수 없습니다.');
      throw '페이지를 열 수 없습니다.';
    }
  }
}

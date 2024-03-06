import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/event_model.dart';
import 'package:ggsb_project/src/repositories/event_repository.dart';
import 'package:uuid/uuid.dart';

class EventCreatePageController extends GetxController {
  static EventCreatePageController get to => Get.find();
  Uuid uuid = Uuid();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();

  Rx<bool> isPageLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> addEventButton() async {
    if (titleController.text == '') {
      openAlertDialog(title: '방 이름을 입력해주세요');
    } else {
      isPageLoading(true);
      //이벤트 모델 업로드
      EventModel eventModel = EventModel(
        title: titleController.text,
        content: contentController.text,
        imgUrl: imgUrlController.text,
        createdAt: DateTime.now(),
      );
      EventRepository().createEvent(eventModel);
      Get.back();
    }
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    contentController.dispose();
    imgUrlController.dispose();
  }
}

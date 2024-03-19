import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/coupon_model.dart';
import 'package:ggsb_project/src/repositories/coupon_repository.dart';
import 'package:uuid/uuid.dart';

class CouponCreateController extends GetxController {
  static CouponCreateController get to => Get.find();
  Uuid uuid = const Uuid();

  TextEditingController codeController = TextEditingController();
  TextEditingController cashController = TextEditingController();

  Rx<bool> isPageLoading = false.obs;


  Future<void> addEventButton() async {
    if (codeController.text == '') {
      openAlertDialog(title: '코드를 입력해주세요');
    } else {
      isPageLoading(true);
      //쿠폰 모델 업로드
      CouponModel couponModel = CouponModel(
        code: codeController.text,
        cash: cashController as int,
        createdAt: DateTime.now(),
      );
      CouponRepository().createCoupon(couponModel);
      Get.back();
    }
  }

  @override
  void onClose() {
    super.onClose();
    codeController.dispose();
    cashController.dispose();
  }
}

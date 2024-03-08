import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/coupon_model.dart';

class CouponRepository {
  Future<void> createCoupon(CouponModel couponModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('coupons')
          .doc(couponModel.code)
          .set(couponModel.toJson());
    } catch (e) {
      openAlertDialog(title: '쿠폰 생성에 실패했습니다.', content: e.toString());
    }
  }

  Future<CouponModel?> getCoupon(String code) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('coupons')
          .where('code', isEqualTo: code)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return CouponModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        // 일치하는 코드를 가진 쿠폰이 없는 경우
        return null;
      }
    } catch (e) {
      openAlertDialog(
        title: '쿠폰 불러오기에 실패했습니다.',
        content: e.toString(),
      );
      return null; // 예외가 발생하면 null 반환
    }
  }
}

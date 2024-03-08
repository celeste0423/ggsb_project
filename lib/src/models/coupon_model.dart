class CouponModel {
  final String? code;
  final int? cash;
  final DateTime? createdAt;

  CouponModel({
    this.code,
    this.cash,
    this.createdAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] == null ? null : json['code'] as String,
      cash: json['cash'] == null ? null : json['cash'] as int,
      createdAt: json['createdAt'] == null ? null : json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'cash': cash,
      'createdAt': createdAt,
    };
  }

  CouponModel copyWith({
    String? code,
    int? cash,
    DateTime? createdAt,
  }) {
    return CouponModel(
      code: code ?? this.code,
      cash: cash ?? this.cash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

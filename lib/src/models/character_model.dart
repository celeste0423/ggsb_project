class CharacterModel {
  final int? actionState;
  final int? bodyColor;
  final int? shield;
  final int? hat;
  final List<String>? purchasedItem;

  CharacterModel({
    this.actionState,
    this.bodyColor,
    this.shield,
    this.hat,
    this.purchasedItem,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      actionState:
          json['actionState'] == null ? null : json['actionState'] as int,
      bodyColor: json['bodyColor'] == null ? null : json['bodyColor'] as int,
      shield: json['shield'] == null ? null : json['shield'] as int,
      hat: json['hat'] == null ? null : json['hat'] as int,
      purchasedItem: json['purchasedItem'] == null
          ? null
          : List<String>.from(json['purchasedItem']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionState': actionState,
      'bodyColor': bodyColor,
      'shield': shield,
      'hat': hat,
      'purchasedItem': purchasedItem,
    };
  }

  CharacterModel copyWith({
    int? actionState,
    int? sleepyState,
    int? bodyColor,
    int? shield,
    int? hat,
    List<String>? purchasedItem,
  }) {
    return CharacterModel(
      actionState: actionState ?? this.actionState,
      bodyColor: bodyColor ?? this.bodyColor,
      shield: shield ?? this.shield,
      hat: hat ?? this.hat,
      purchasedItem: purchasedItem ?? this.purchasedItem,
    );
  }
}

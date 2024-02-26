class CharacterModel {
  final int? fightState;
  final int? sleepyState;
  final int? bodyColor;
  final int? shield;
  final int? hat;
  final List<String>? purchasedItem;

  CharacterModel({
    this.fightState,
    this.sleepyState,
    this.bodyColor,
    this.shield,
    this.hat,
    this.purchasedItem,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      fightState: json['fightState'] == null ? null : json['fightState'] as int,
      sleepyState:
          json['sleepyState'] == null ? null : json['sleepyState'] as int,
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
      'fightState': fightState,
      'sleepyState': sleepyState,
      'bodyColor': bodyColor,
      'shield': shield,
      'hat': hat,
      'purchasedItem': purchasedItem,
    };
  }

  CharacterModel copyWith({
    int? fightState,
    int? sleepyState,
    int? bodyColor,
    int? shield,
    int? hat,
    List<String>? purchasedItem,
  }) {
    return CharacterModel(
      fightState: fightState ?? this.fightState,
      sleepyState: sleepyState ?? this.sleepyState,
      bodyColor: bodyColor ?? this.bodyColor,
      shield: shield ?? this.shield,
      hat: hat ?? this.hat,
      purchasedItem: purchasedItem ?? this.purchasedItem,
    );
  }
}

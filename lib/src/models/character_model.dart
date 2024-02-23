class CharacterModel {
  final int? fightState;
  final int? sleepyState;
  final int? bodyColor;
  final List<String>? purchasedBodyColor;
  final int? shield;
  final List<String>? purchasedShield;
  final int? hat;
  final List<String>? purchasedHat;

  CharacterModel({
    this.fightState,
    this.sleepyState,
    this.bodyColor,
    this.purchasedBodyColor,
    this.shield,
    this.purchasedShield,
    this.hat,
    this.purchasedHat,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      fightState: json['fightState'] == null ? null : json['fightState'] as int,
      sleepyState:
          json['sleepyState'] == null ? null : json['sleepyState'] as int,
      bodyColor: json['bodyColor'] == null ? null : json['bodyColor'] as int,
      purchasedBodyColor: json['purchasedBodyColor'] == null
          ? null
          : List<String>.from(json['purchasedBodyColor']),
      shield: json['shield'] == null ? null : json['shield'] as int,
      purchasedShield: json['purchasedShield'] == null
          ? null
          : List<String>.from(json['purchasedShield']),
      hat: json['hat'] == null ? null : json['hat'] as int,
      purchasedHat: json['purchasedHat'] == null
          ? null
          : List<String>.from(json['purchasedHat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fightState': fightState,
      'sleepyState': sleepyState,
      'bodyColor': bodyColor,
      'purchasedBodyColor': purchasedBodyColor,
      'shield': shield,
      'purchasedShield': purchasedShield,
      'hat': hat,
      'purchasedHat': purchasedHat,
    };
  }

  CharacterModel copyWith({
    int? fightState,
    int? sleepyState,
    int? bodyColor,
    List<String>? purchasedBodyColor,
    int? shield,
    List<String>? purchasedShield,
    int? hat,
    List<String>? purchasedHat,
  }) {
    return CharacterModel(
      fightState: fightState ?? this.fightState,
      sleepyState: sleepyState ?? this.sleepyState,
      bodyColor: bodyColor ?? this.bodyColor,
      purchasedBodyColor: purchasedBodyColor ?? this.purchasedBodyColor,
      shield: shield ?? this.shield,
      purchasedShield: purchasedShield ?? this.purchasedShield,
      hat: hat ?? this.hat,
      purchasedHat: purchasedHat ?? this.purchasedHat,
    );
  }
}

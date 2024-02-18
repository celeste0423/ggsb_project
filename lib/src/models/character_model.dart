class CharacterModel {
  final int? fightState;
  final int? sleepyState;
  final int? bodyColor;
  final int? hat;

  CharacterModel({
    this.fightState,
    this.sleepyState,
    this.bodyColor,
    this.hat,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      fightState: json['fightState'] == null ? null : json['fightState'] as int,
      sleepyState:
          json['sleepyState'] == null ? null : json['sleepyState'] as int,
      bodyColor: json['bodyColor'] == null ? null : json['bodyColor'] as int,
      hat: json['hat'] == null ? null : json['hat'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fightState': fightState,
      'sleepyState': sleepyState,
      'bodyColor': bodyColor,
      'hat': hat,
    };
  }

  CharacterModel copyWith({
    int? fightState,
    int? sleepyState,
    int? bodyColor,
    int? hat,
  }) {
    return CharacterModel(
      fightState: fightState ?? this.fightState,
      sleepyState: sleepyState ?? this.sleepyState,
      bodyColor: bodyColor ?? this.bodyColor,
      hat: hat ?? this.hat,
    );
  }
}

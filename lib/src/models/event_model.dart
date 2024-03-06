class EventModel {
  final String? title;
  final String? content;
  final String? imgUrl;
  final DateTime? createdAt;

  EventModel({
    this.title,
    this.content,
    this.imgUrl,
    this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'] == null ? null : json['title'] as String,
      content: json['content'] == null ? null : json['content'] as String,
      imgUrl: json['imgUrl'] == null ? null : json['imgUrl'] as String,
      createdAt: json['createdAt'] == null ? null : json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imgUrl': imgUrl,
      'createdAt': createdAt,
    };
  }

  EventModel copyWith({
    String? title,
    String? content,
    String? imgUrl,
    DateTime? createdAt,
  }) {
    return EventModel(
      title: title ?? this.title,
      content: content ?? this.content,
      imgUrl: imgUrl ?? this.imgUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

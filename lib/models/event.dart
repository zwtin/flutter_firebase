import 'package:meta/meta.dart';

@immutable
class Event {
  const Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.imageUrl,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(date != null),
        assert(imageUrl != null);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        date = json['date'] as DateTime,
        imageUrl = json['image_url'] as String;

  final String id; // ID
  final String title; // タイトル
  final String description; // 紹介文
  final DateTime date; // 開催日
  final String imageUrl; // イベント画像(URL)
}

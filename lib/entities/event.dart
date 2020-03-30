import 'package:meta/meta.dart';

@immutable
class Event {
  const Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.imageUrl,
    @required this.isOwnLike,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(date != null),
        assert(imageUrl != null),
        assert(isOwnLike != null);

  final String id; // ID
  final String title; // タイトル
  final String description; // 紹介文
  final DateTime date; // 開催日
  final String imageUrl; // イベント画像(URL)
  final bool isOwnLike; // イベント画像(URL)
}
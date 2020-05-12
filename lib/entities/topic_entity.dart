import 'package:meta/meta.dart';

@immutable
class TopicEntity {
  const TopicEntity({
    @required this.id,
    @required this.text,
    @required this.imageUrl,
    @required this.createdAt,
    @required this.createdUser,
  })  : assert(id != null),
        assert(text != null),
        assert(imageUrl != null),
        assert(createdAt != null),
        assert(createdUser != null);

  final String id;
  final String text;
  final String imageUrl;
  final DateTime createdAt;
  final String createdUser;
}

import 'package:meta/meta.dart';

@immutable
class Topic {
  const Topic({
    @required this.id,
    @required this.text,
    @required this.imageUrl,
    @required this.createdAt,
    @required this.createdUserId,
    @required this.createdUserName,
    @required this.createdUserImageUrl,
  })  : assert(id != null),
        assert(text != null),
        assert(imageUrl != null),
        assert(createdAt != null),
        assert(createdUserId != null),
        assert(createdUserName != null),
        assert(createdUserImageUrl != null);

  final String id;
  final String text;
  final String imageUrl;
  final DateTime createdAt;
  final String createdUserId;
  final String createdUserName;
  final String createdUserImageUrl;
}

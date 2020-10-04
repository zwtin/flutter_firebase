import 'package:meta/meta.dart';

@immutable
class Answer {
  const Answer({
    @required this.id,
    @required this.text,
    @required this.createdAt,
    @required this.rank,
    @required this.topicId,
    @required this.topicText,
    @required this.topicImageUrl,
    @required this.topicCreatedAt,
    @required this.topicCreatedUserId,
    @required this.topicCreatedUserName,
    @required this.topicCreatedUserImageUrl,
    @required this.createdUserId,
    @required this.createdUserName,
    @required this.createdUserImageUrl,
  })  : assert(id != null),
        assert(text != null),
        assert(createdAt != null),
        assert(rank != null),
        assert(topicId != null),
        assert(topicText != null),
        assert(topicImageUrl != null),
        assert(topicCreatedAt != null),
        assert(topicCreatedAt != null),
        assert(topicCreatedUserId != null),
        assert(topicCreatedUserName != null),
        assert(topicCreatedUserImageUrl != null),
        assert(createdUserId != null),
        assert(createdUserName != null),
        assert(createdUserImageUrl != null);

  final String id;
  final String text;
  final DateTime createdAt;
  final int rank;
  final String topicId;
  final String topicText;
  final String topicImageUrl;
  final DateTime topicCreatedAt;
  final String topicCreatedUserId;
  final String topicCreatedUserName;
  final String topicCreatedUserImageUrl;
  final String createdUserId;
  final String createdUserName;
  final String createdUserImageUrl;
}

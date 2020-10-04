import 'package:meta/meta.dart';

@immutable
class AnswerEntity {
  const AnswerEntity({
    @required this.id,
    @required this.text,
    @required this.createdAt,
    @required this.rank,
    @required this.topicId,
    @required this.createdUser,
  })  : assert(id != null),
        assert(text != null),
        assert(createdAt != null),
        assert(rank != null),
        assert(topicId != null),
        assert(createdUser != null);

  final String id;
  final String text;
  final DateTime createdAt;
  final int rank;
  final String topicId;
  final String createdUser;
}

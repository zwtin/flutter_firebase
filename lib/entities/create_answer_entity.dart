import 'package:meta/meta.dart';

@immutable
class CreateAnswerEntity {
  const CreateAnswerEntity({
    @required this.id,
    @required this.createdAt,
  })  : assert(id != null),
        assert(createdAt != null);

  final String id;
  final DateTime createdAt;
}

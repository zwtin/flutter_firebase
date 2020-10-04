import 'package:flutter_firebase/use_cases/answer_entity.dart';
import 'package:meta/meta.dart';

@immutable
class GetUserCreateAnswerListResponse {
  const GetUserCreateAnswerListResponse({
    @required this.answers,
    @required this.hasNext,
  })  : assert(answers != null),
        assert(hasNext != null);
  final List<AnswerEntity> answers;
  final bool hasNext;
}

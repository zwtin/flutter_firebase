import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:meta/meta.dart';

@immutable
class GetPopularAnswerListResponse {
  const GetPopularAnswerListResponse({
    @required this.answers,
    @required this.hasNext,
  })  : assert(answers != null),
        assert(hasNext != null);
  final List<Answer> answers;
  final bool hasNext;
}

import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:meta/meta.dart';

@immutable
class GetAnswerResponse {
  const GetAnswerResponse({
    @required this.answer,
  }) : assert(answer != null);

  final Answer answer;
}

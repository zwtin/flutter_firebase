import 'package:meta/meta.dart';

@immutable
class GetNewAnswerListParameter {
  const GetNewAnswerListParameter({
    @required this.createdAt,
  });
  final DateTime createdAt;
}

import 'package:meta/meta.dart';

@immutable
class GetUserCreateAnswerListParameter {
  const GetUserCreateAnswerListParameter({
    @required this.userId,
    @required this.createdAt,
  }) : assert(userId != null);
  final String userId;
  final DateTime createdAt;
}

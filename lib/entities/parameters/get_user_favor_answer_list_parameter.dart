import 'package:meta/meta.dart';

@immutable
class GetUserFavorAnswerListParameter {
  const GetUserFavorAnswerListParameter({
    @required this.userId,
    @required this.favorAt,
  }) : assert(userId != null);
  final String userId;
  final DateTime favorAt;
}

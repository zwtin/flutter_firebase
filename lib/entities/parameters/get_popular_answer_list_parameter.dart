import 'package:meta/meta.dart';

@immutable
class GetPopularAnswerListParameter {
  const GetPopularAnswerListParameter({
    @required this.rank,
  });
  final int rank;
}

import 'package:meta/meta.dart';

@immutable
class GetAnswerParameter {
  const GetAnswerParameter({
    @required this.id,
  }) : assert(id != null);
  final String id;
}

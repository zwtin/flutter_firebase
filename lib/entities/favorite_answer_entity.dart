import 'package:meta/meta.dart';

@immutable
class FavoriteAnswerEntity {
  const FavoriteAnswerEntity({
    @required this.id,
    @required this.favoredAt,
  })  : assert(id != null),
        assert(favoredAt != null);

  final String id;
  final DateTime favoredAt;
}

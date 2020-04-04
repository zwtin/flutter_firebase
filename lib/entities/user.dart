import 'package:meta/meta.dart';

@immutable
class User {
  const User({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.introduction,
  })  : assert(id != null),
        assert(name != null),
        assert(imageUrl != null),
        assert(introduction != null);

  final String id;
  final String name;
  final String imageUrl;
  final String introduction;
}

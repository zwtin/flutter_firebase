import 'package:meta/meta.dart';

@immutable
class User {
  const User({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.introduction,
    @required this.postedItems,
    @required this.favoriteItems,
  })  : assert(id != null),
        assert(name != null);

  final String id;
  final String name;
  final String imageUrl;
  final String introduction;
  final List<String> postedItems;
  final List<String> favoriteItems;
}

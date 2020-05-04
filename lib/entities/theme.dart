import 'package:meta/meta.dart';

@immutable
class Theme {
  const Theme({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.imageUrl,
    @required this.createdUser,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(date != null),
        assert(imageUrl != null),
        assert(createdUser != null);

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imageUrl;
  final String createdUser;
}

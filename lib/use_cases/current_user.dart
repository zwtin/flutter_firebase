import 'package:meta/meta.dart';

@immutable
class CurrentUser {
  const CurrentUser({
    @required this.id,
  }) : assert(id != null);

  final String id;
}

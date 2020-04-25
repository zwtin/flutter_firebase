import 'package:meta/meta.dart';
import 'package:sweetalert/sweetalert.dart';

@immutable
class Alert {
  const Alert({
    @required this.title,
    @required this.subtitle,
    @required this.style,
    @required this.showCancelButton,
    @required this.onPress,
  });

  final String title;
  final String subtitle;
  final SweetAlertStyle style;
  final bool showCancelButton;
  final SweetAlertOnPress onPress;
}

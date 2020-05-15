import 'dart:math';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension StringExtension on String {
  static String randomString(int length) {
    const _randomChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const _charsLength = _randomChars.length;

    final rand = Random();
    final codeUnits = List.generate(
      length,
      (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return String.fromCharCodes(codeUnits);
  }

  static String getJPStringFromDateTime(DateTime dateTime) {
    initializeDateFormatting('ja_JP');
    final formatter = DateFormat('yyyy/MM/dd(E) HH:mm', 'ja_JP');
    final formatted = formatter.format(dateTime); // DateからString
    return formatted;
  }
}

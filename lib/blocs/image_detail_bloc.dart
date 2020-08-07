import 'dart:async';

import 'package:flutter/cupertino.dart';

class ImageDetailBloc {
  ImageDetailBloc(this.imageUrl) : assert(imageUrl != null);

  final String imageUrl;

  Future<void> dispose() async {}
}

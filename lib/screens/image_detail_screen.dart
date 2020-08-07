import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/image_detail_bloc.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageDetailBloc = Provider.of<ImageDetailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(imageDetailBloc.imageUrl),
        ),
      ),
    );
  }
}

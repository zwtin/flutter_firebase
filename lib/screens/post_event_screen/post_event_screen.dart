import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:flutter_firebase/blocs/post_event_bloc/post_event_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class PostEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postEventBloc = Provider.of<PostEventBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ホーム',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: postEventBloc.loadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return LoadingOverlay(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.grey,
                        height: 200,
                        width: 200,
                        child: StreamBuilder(
                          stream: postEventBloc.imageFileController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<File> imageSnapshot) {
                            if (imageSnapshot.hasData) {
                              return Image.file(imageSnapshot.data);
                            }
                            return StreamBuilder(
                              stream: postEventBloc.imageController,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snap) {
                                return CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: snap.data.toString(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      onTap: postEventBloc.getImage,
                    ),
                  ),
                  const Text('ユーザー名'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: postEventBloc.nameController,
                    ),
                  ),
                  const Text('一言'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: postEventBloc.introductionController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('確定'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: postEventBloc.updateProfile,
                  ),
                ],
              ),
            ),
            isLoading: snapshot.data ?? false,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/post_theme_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class PostTopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postThemeBloc = Provider.of<PostTopicBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'お題投稿',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFCC00),
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            color: Colors.white24,
            height: 1,
          ),
          preferredSize: const Size.fromHeight(1),
        ),
      ),
      body: StreamBuilder(
        stream: postThemeBloc.loadingController.stream,
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
                        color: Color.fromRGBO(210, 210, 210, 1),
                        height: 200,
                        width: 200,
                        child: StreamBuilder(
                          stream: postThemeBloc.imageFileController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<File> imageSnapshot) {
                            if (imageSnapshot.hasData) {
                              return Image.file(imageSnapshot.data);
                            }
                            return StreamBuilder(
                              stream: postThemeBloc.imageController,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snap) {
                                return CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: snap.data.toString(),
                                  errorWidget: (context, url, dynamic error) =>
                                      Image.asset('assets/icon/no_image.jpg'),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      onTap: postThemeBloc.getImage,
                    ),
                  ),
                  const Text('タイトル'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: postThemeBloc.titleController,
                    ),
                  ),
                  const Text('詳細'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: postThemeBloc.descriptionController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('投稿'),
                    color: const Color(0xFFFFCC00),
                    textColor: Colors.white,
                    onPressed: postThemeBloc.postTopic,
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

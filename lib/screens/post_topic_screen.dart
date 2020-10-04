import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/post_topic_bloc.dart';
import 'package:flutter_firebase/use_cases/alert.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';

class PostTopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postTopicBloc = Provider.of<PostTopicBloc>(context);

    postTopicBloc.alertController.stream.listen(
      (Alert alert) {
        SweetAlert.show(
          context,
          title: alert.title,
          subtitle: alert.subtitle,
          style: alert.style,
          showCancelButton: alert.showCancelButton,
          onPress: alert.onPress,
        );
      },
    );

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
        stream: postTopicBloc.loadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
          return LoadingOverlay(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: InkWell(
                      child: Container(
                        color: Color.fromRGBO(210, 210, 210, 1),
                        height: 200,
                        width: 200,
                        child: StreamBuilder(
                          stream: postTopicBloc.imageFileController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<File> imageFileSnapshot) {
                            if (imageFileSnapshot.hasData) {
                              return Image.file(imageFileSnapshot.data);
                            }
                            return Image.asset('assets/icon/no_image.jpg');
                          },
                        ),
                      ),
                      onTap: postTopicBloc.getImage,
                    ),
                  ),
                  const Text('テキスト'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: postTopicBloc.textController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('投稿'),
                    color: const Color(0xFFFFCC00),
                    textColor: Colors.white,
                    onPressed: postTopicBloc.postTopic,
                  ),
                ],
              ),
            ),
            isLoading: loadingSnapshot.data ?? false,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}

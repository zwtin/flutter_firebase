import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/post_event_bloc.dart';
import 'package:flutter_firebase/common/string_extension.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class PostEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postEventBloc = Provider.of<PostEventBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ボケ投稿',
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
        stream: postEventBloc.loadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return LoadingOverlay(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    imageUrl:
                                        postEventBloc.topic.createdUserImageUrl,
                                    errorWidget: (context, url,
                                            dynamic error) =>
                                        Image.asset('assets/icon/no_image.jpg'),
                                  ),
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      '${StringExtension.getJPStringFromDateTime(postEventBloc.topic.createdAt)}'),
                                  Text(
                                      '${postEventBloc.topic.createdUserName} さんからのお題：'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              postEventBloc.topic.text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        postEventBloc.topic.imageUrl.isEmpty
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: postEventBloc.topic.imageUrl,
                                  errorWidget: (context, url, dynamic error) =>
                                      Image.asset('assets/icon/no_image.jpg'),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                  const Text('回答'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: postEventBloc.answerController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('投稿'),
                    color: const Color(0xFFFFCC00),
                    textColor: Colors.white,
                    onPressed: postEventBloc.postAnswer,
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

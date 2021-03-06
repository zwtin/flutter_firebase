import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/post_event_bloc.dart';
import 'package:flutter_firebase/common/string_extension.dart';
import 'package:flutter_firebase/use_cases/topic.dart';
import 'package:flutter_firebase/models/firestore_answer_repository.dart';
import 'package:flutter_firebase/screens/post_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/screens/new_register_screen.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/blocs/post_topic_select_bloc.dart';

class PostTopicSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postTopicSelectBloc = Provider.of<PostTopicSelectBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'お題選択',
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
      body: Stack(
        children: <Widget>[
          Container(
            color: const Color(0xFFFFCC00),
          ),
          RefreshIndicator(
            color: const Color(0xFFFFCC00),
            onRefresh: postTopicSelectBloc.start,
            child: Scrollbar(
              child: StreamBuilder(
                stream: postTopicSelectBloc.topicController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Topic>> snapshot) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<PostEventScreen>(
                                builder: (BuildContext context) {
                                  return Provider<PostEventBloc>(
                                    create: (BuildContext context) {
                                      return PostEventBloc(
                                        snapshot.data.elementAt(index),
                                        FirebaseAuthenticationRepository(),
                                        FirestoreAnswerRepository(),
                                      );
                                    },
                                    dispose: (BuildContext context,
                                        PostEventBloc bloc) {
                                      bloc.dispose();
                                    },
                                    child: PostEventScreen(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: Row(
                                  children: <Widget>[
                                    ClipOval(
                                      child: SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          imageUrl: snapshot.data
                                              .elementAt(index)
                                              .createdUserImageUrl,
                                          errorWidget: (context, url,
                                                  dynamic error) =>
                                              Image.asset(
                                                  'assets/icon/no_image.jpg'),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            '${StringExtension.getJPStringFromDateTime(snapshot.data.elementAt(index).createdAt)}'),
                                        Text(
                                            '${snapshot.data.elementAt(index).createdUserName} さんからのお題：'),
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
                                    snapshot.data.elementAt(index).text,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              snapshot.data.elementAt(index).imageUrl.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 16),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl: snapshot.data
                                            .elementAt(index)
                                            .imageUrl,
                                        errorWidget:
                                            (context, url, dynamic error) =>
                                                Image.asset(
                                                    'assets/icon/no_image.jpg'),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.hasData ? snapshot.data.length : 0,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

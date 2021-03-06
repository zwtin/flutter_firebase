import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/image_detail_bloc.dart';
import 'package:flutter_firebase/blocs/profile_bloc.dart';
import 'package:flutter_firebase/models/firestore_sample_repository.dart';
import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/blocs/event_detail_bloc.dart';
import 'package:flutter_firebase/models/firestore_answer_repository.dart';
import 'package:flutter_firebase/models/firestore_topic_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/image_detail_screen.dart';
import 'package:flutter_firebase/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/common/string_extension.dart';

class EventDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventDetailBloc = Provider.of<EventDetailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '詳細',
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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: eventDetailBloc.answerController.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<Answer> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 16,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 16,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<ProfileScreen>(
                                            builder: (BuildContext context) {
                                              return Provider<ProfileBloc>(
                                                create: (BuildContext context) {
                                                  return ProfileBloc(
                                                    snapshot.data
                                                        .topicCreatedUserId,
                                                    FirestoreUserRepository(),
                                                    FirestoreAnswerRepository(),
                                                    FirestoreTopicRepository(),
                                                    FirestoreSampleRepository(),
                                                  );
                                                },
                                                dispose: (BuildContext context,
                                                    ProfileBloc bloc) {
                                                  bloc.dispose();
                                                },
                                                child: ProfileScreen(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          ClipOval(
                                            child: SizedBox(
                                              width: 44,
                                              height: 44,
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                imageUrl: snapshot.data
                                                    .topicCreatedUserImageUrl,
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
                                                  '${StringExtension.getJPStringFromDateTime(snapshot.data.topicCreatedAt)}'),
                                              Text(
                                                  '${snapshot.data.topicCreatedUserName} さんからのお題：'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.data.topicText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                snapshot.data.topicImageUrl.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          imageUrl: snapshot.data.topicImageUrl,
                                          errorWidget: (context, url,
                                                  dynamic error) =>
                                              Image.asset(
                                                  'assets/icon/no_image.jpg'),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 16,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 16,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<ProfileScreen>(
                                            builder: (BuildContext context) {
                                              return Provider<ProfileBloc>(
                                                create: (BuildContext context) {
                                                  return ProfileBloc(
                                                    snapshot.data
                                                        .answerCreatedUserId,
                                                    FirestoreUserRepository(),
                                                    FirestoreAnswerRepository(),
                                                    FirestoreTopicRepository(),
                                                    FirestoreSampleRepository(),
                                                  );
                                                },
                                                dispose: (BuildContext context,
                                                    ProfileBloc bloc) {
                                                  bloc.dispose();
                                                },
                                                child: ProfileScreen(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          ClipOval(
                                            child: SizedBox(
                                              width: 44,
                                              height: 44,
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                imageUrl: snapshot.data
                                                    .answerCreatedUserImageUrl,
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
                                                  '${StringExtension.getJPStringFromDateTime(snapshot.data.answerCreatedAt)}'),
                                              Text(
                                                  '${snapshot.data.answerCreatedUserName} さんの回答：'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.data.answerText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    StreamBuilder(
                      stream: eventDetailBloc.likeController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> likeSnapshot) {
                        return IconButton(
                          icon: likeSnapshot.data
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                )
                              : Icon(Icons.favorite_border),
                          onPressed: eventDetailBloc.likeButtonAction,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: eventDetailBloc.likeCountController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<int> likeCountSnapshot) {
                        if (likeCountSnapshot.hasData) {
                          return Text(likeCountSnapshot.data.toString());
                        } else {
                          return Container();
                        }
                      },
                    ),
                    StreamBuilder(
                      stream: eventDetailBloc.favoriteController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> favoriteSnapshot) {
                        return IconButton(
                          icon: favoriteSnapshot.data
                              ? Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )
                              : Icon(Icons.star_border),
                          onPressed: eventDetailBloc.favoriteButtonAction,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: eventDetailBloc.favoriteCountController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<int> favoriteCountSnapshot) {
                        if (favoriteCountSnapshot.hasData) {
                          return Text(favoriteCountSnapshot.data.toString());
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

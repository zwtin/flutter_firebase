import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/post_topic_bloc.dart';
import 'package:flutter_firebase/blocs/post_topic_select_bloc.dart';
import 'package:flutter_firebase/models/firebase_storage_repository.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/models/firestore_topic_repository.dart';
import 'package:flutter_firebase/screens/post_topic_screen.dart';
import 'package:flutter_firebase/screens/post_topic_select_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/screens/new_register_screen.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/blocs/post_category_select_bloc.dart';

class PostCategorySelectScreen extends StatelessWidget {
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final postCategorySelectBloc = Provider.of<PostCategorySelectBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'カテゴリー選択',
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
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<PostTopicScreen>(
                            builder: (BuildContext context) {
                              return Provider<PostTopicBloc>(
                                create: (BuildContext context) {
                                  return PostTopicBloc(
                                    FirebaseAuthenticationRepository(),
                                    FirestoreTopicRepository(),
                                    FirebaseStorageRepository(),
                                  );
                                },
                                dispose:
                                    (BuildContext context, PostTopicBloc bloc) {
                                  bloc.dispose();
                                },
                                child: PostTopicScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'お題を投稿する',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                  break;
                case 1:
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<PostTopicSelectScreen>(
                            builder: (BuildContext context) {
                              return Provider<PostTopicSelectBloc>(
                                create: (BuildContext context) {
                                  return PostTopicSelectBloc(
                                    FirestoreTopicRepository(),
                                    FirestoreUserRepository(),
                                  );
                                },
                                dispose: (BuildContext context,
                                    PostTopicSelectBloc bloc) {
                                  bloc.dispose();
                                },
                                child: PostTopicSelectScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'ボケを投稿する',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                  break;
                default:
                  break;
              }
              return Container();
            },
            itemCount: 2,
          ),
        ],
      ),
    );
  }
}

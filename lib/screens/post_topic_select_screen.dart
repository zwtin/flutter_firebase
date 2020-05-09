import 'dart:async';
import 'package:flutter/material.dart';
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
          ListView.builder(
            itemBuilder: (context, index) {
              return Text('$index');
            },
          ),
        ],
      ),
    );
  }
}

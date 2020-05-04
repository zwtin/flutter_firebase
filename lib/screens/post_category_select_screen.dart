import 'dart:async';
import 'package:flutter/material.dart';
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
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(16),
                child: index == 0
                    ? const Text(
                        'お題を投稿する',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    : const Text(
                        'ボケを投稿する',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          );
        },
        itemCount: 2,
      ),
    );
  }
}

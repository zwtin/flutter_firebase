import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/entities/topic.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PostEventBloc {
  PostEventBloc(
    this.topic,
    this._authenticationRepository,
    this._itemRepository,
  )   : assert(topic != null),
        assert(_authenticationRepository != null),
        assert(_itemRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final ItemRepository _itemRepository;
  final Topic topic;

  final TextEditingController answerController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> postItem() async {
    loadingController.sink.add(true);
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _itemRepository.postItem(
        userId: currentUser.id,
        item: Item(
          id: 'a',
          title: answerController.text,
          description: answerController.text,
          date: DateTime.now(),
          imageUrl: '',
          createdUser: currentUser.id,
        ),
      );
      loadingController.sink.add(false);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> dispose() async {
    await loadingController.close();
  }
}

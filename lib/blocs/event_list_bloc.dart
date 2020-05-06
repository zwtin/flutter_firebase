import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventListBloc {
  EventListBloc(this._itemRepository) : assert(_itemRepository != null) {
    start();
  }

  final ItemRepository _itemRepository;

  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> popTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  final BehaviorSubject<List<Item>> itemController =
      BehaviorSubject<List<Item>>.seeded([]);

  Future<void> start() async {
    try {
      final items = await _itemRepository.getItemList();
      items.sort((a, b) => b.date.compareTo(a.date));
      itemController.sink.add(items);
    } on Exception catch (error) {
      return;
    }
  }

  Future<void> dispose() async {
    await rootTransitionSubscription.cancel();
    await popTransitionSubscription.cancel();
    await newRegisterSubscription.cancel();
    await itemController.close();
  }
}

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

  final BehaviorSubject<List<Item>> itemController =
      BehaviorSubject<List<Item>>.seeded([]);
  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> start() async {
    loadingController.sink.add(true);
    try {
      final items = await _itemRepository.getItemList();
      items.sort((a, b) => b.date.compareTo(a.date));
      loadingController.sink.add(false);
      itemController.sink.add(items);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> dispose() async {
    await itemController.close();
    await loadingController.close();
  }
}

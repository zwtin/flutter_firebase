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

  Future<void> start() async {
    final items = await _itemRepository.getItemList();
    itemController.sink.add(items);
  }

  Future<void> dispose() async {
    await itemController.close();
  }
}

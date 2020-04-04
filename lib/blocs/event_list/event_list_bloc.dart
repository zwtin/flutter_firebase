import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventListBloc implements Bloc {
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

  @override
  Future<void> dispose() async {
    await itemController.close();
  }
}

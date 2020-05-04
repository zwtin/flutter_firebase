import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/item.dart';

abstract class ItemRepository {
  Stream<List<Item>> getItemListStream();
  Future<List<Item>> getItemList();
  Stream<Item> getItemDetail({@required String id});
  Stream<List<Item>> getSelectedItemListStream({@required List<String> ids});
  Future<void> postItem({@required String userId, @required Item item});
}

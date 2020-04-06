import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';

class EventDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '詳細',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              StreamBuilder(
                stream: eventDetailBloc.itemController.stream,
                builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          snapshot.data.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(snapshot.data.date.toIso8601String()),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 128,
                            height: 128,
                            child: FutureBuilder<dynamic>(
                              future: FirebaseStorage.instance
                                  .ref()
                                  .child(snapshot.data.imageUrl)
                                  .getDownloadURL(),
                              builder: (context, snap) {
                                return CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: snap.data.toString(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: eventDetailBloc.likeButtonAction,
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: eventDetailBloc.favoriteController.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> favoriteSnapshot) {
                      return IconButton(
                        icon: favoriteSnapshot.data
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        onPressed: eventDetailBloc.favoriteButtonAction,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/blocs/event_detail_bloc.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventDetailBloc = Provider.of<EventDetailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '詳細',
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
          StreamBuilder(
            stream: eventDetailBloc.itemController.stream,
            builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ClipOval(
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Image.asset('assets/icon/no_user.jpg'),
                                ),
                              ),
                              Text('〇〇さんからのお題：'),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          snapshot.data.imageUrl.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(16),
                                  child: FutureBuilder<dynamic>(
                                    future: FirebaseStorage.instance
                                        .ref()
                                        .child(snapshot.data.imageUrl)
                                        .getDownloadURL(),
                                    builder: (context, snap) {
                                      return CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl: snap.data.toString(),
                                        errorWidget:
                                            (context, url, dynamic error) =>
                                                Image.asset(
                                                    'assets/icon/no_image.jpg'),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ClipOval(
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child:
                                        Image.asset('assets/icon/no_user.jpg'),
                                  ),
                                ),
                                Text('〇〇さんからの回答：'),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  snapshot.data.description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: eventDetailBloc.likeController.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> likeSnapshot) {
                                    return IconButton(
                                      icon: likeSnapshot.data
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.pink,
                                            )
                                          : Icon(Icons.favorite_border),
                                      onPressed:
                                          eventDetailBloc.likeButtonAction,
                                    );
                                  },
                                ),
                                StreamBuilder(
                                  stream:
                                      eventDetailBloc.favoriteController.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> favoriteSnapshot) {
                                    return IconButton(
                                      icon: favoriteSnapshot.data
                                          ? Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            )
                                          : Icon(Icons.star_border),
                                      onPressed:
                                          eventDetailBloc.favoriteButtonAction,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
//      Card(
//        child: Column(
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            StreamBuilder(
//              stream: eventDetailBloc.itemController.stream,
//              builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
//                  return Column(
//                    children: <Widget>[
//                      ListTile(
//                        title: Text(
//                          snapshot.data.title,
//                          style: TextStyle(fontWeight: FontWeight.bold),
//                        ),
//                        subtitle: Text(snapshot.data.date.toIso8601String()),
//                      ),
//                      Row(
//                        children: <Widget>[
//                          SizedBox(
//                            width: 128,
//                            height: 128,
//                            child: FutureBuilder<dynamic>(
//                              future: FirebaseStorage.instance
//                                  .ref()
//                                  .child(snapshot.data.imageUrl)
//                                  .getDownloadURL(),
//                              builder: (context, snap) {
//                                return CachedNetworkImage(
//                                  placeholder: (context, url) => const Center(
//                                    child: CircularProgressIndicator(),
//                                  ),
//                                  imageUrl: snap.data.toString(),
//                                  errorWidget: (context, url, dynamic error) =>
//                                      Image.asset('assets/icon/no_image.jpg'),
//                                );
//                              },
//                            ),
//                          ),
//                        ],
//                      ),
//                    ],
//                  );
//                },
//              ),
//              Row(
//                children: <Widget>[
//                  StreamBuilder(
//                    stream: eventDetailBloc.likeController.stream,
//                    builder: (BuildContext context,
//                        AsyncSnapshot<bool> likeSnapshot) {
//                      return IconButton(
//                        icon: likeSnapshot.data
//                            ? Icon(Icons.favorite)
//                            : Icon(Icons.favorite_border),
//                        onPressed: eventDetailBloc.likeButtonAction,
//                      );
//                    },
//                  ),
//                  StreamBuilder(
//                    stream: eventDetailBloc.favoriteController.stream,
//                    builder: (BuildContext context,
//                        AsyncSnapshot<bool> favoriteSnapshot) {
//                      return IconButton(
//                        icon: favoriteSnapshot.data
//                            ? Icon(Icons.star)
//                            : Icon(Icons.star_border),
//                        onPressed: eventDetailBloc.favoriteButtonAction,
//                      );
//                    },
//                  ),
//                ],
//              )
//            ],
//          ),
//        ),
//      ),
//    );
    );
  }
}

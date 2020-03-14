import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventDetailScreen extends StatelessWidget {
  EventDetailScreen(this._event) : assert(_event != null);
  final Event _event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '詳細',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('no user login'),
            RaisedButton(
              child: const Text('Button'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FutureBuilder<dynamic>(
              future: FirebaseStorage.instance
                  .ref()
                  .child(_event.imageUrl)
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
          ],
        ),
      ),
    );
  }
}

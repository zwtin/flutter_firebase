import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/edit_profile_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editProfileBloc = Provider.of<EditProfileBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ホーム',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: editProfileBloc.loadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return LoadingOverlay(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.grey,
                        height: 200,
                        width: 200,
                        child: StreamBuilder(
                          stream: editProfileBloc.imageFileController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<File> imageSnapshot) {
                            if (imageSnapshot.hasData) {
                              return Image.file(imageSnapshot.data);
                            }
                            return StreamBuilder(
                              stream: editProfileBloc.imageController,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snap) {
                                return CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: snap.data.toString(),
                                  errorWidget: (context, url, dynamic error) =>
                                      Image.asset('assets/icon/no_user.jpg'),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      onTap: editProfileBloc.getImage,
                    ),
                  ),
                  const Text('ユーザー名'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: editProfileBloc.nameController,
                    ),
                  ),
                  const Text('一言'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: editProfileBloc.introductionController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('確定'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: editProfileBloc.updateProfile,
                  ),
                ],
              ),
            ),
            isLoading: snapshot.data ?? false,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}

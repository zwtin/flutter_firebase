import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_state.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editProfileBloc = BlocProvider.of<EditProfileBloc>(context);

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

//    return StreamBuilder(
//      stream: editProfileBloc.screenState,
//      builder: (context, snapshot) {
//        if (snapshot.hasData && snapshot.data is EditProfileInProgress) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ編集',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: Stack(
//              children: <Widget>[
//                Center(
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      const Text('ユーザー名'),
//                      Padding(
//                        padding: const EdgeInsets.all(16),
//                        child: TextField(
//                          onChanged: (String str) {
//                            editProfileBloc.name = str;
//                          },
//                          onSubmitted: (String str) {
//                            editProfileBloc.name = str;
//                          },
//                        ),
//                      ),
//                      const Text('一言'),
//                      Padding(
//                        padding: const EdgeInsets.all(16),
//                        child: TextField(
//                          onChanged: (String str) {
//                            editProfileBloc.introduction = str;
//                          },
//                          onSubmitted: (String str) {
//                            editProfileBloc.introduction = str;
//                          },
//                        ),
//                      ),
//                      RaisedButton(
//                        child: const Text('確定'),
//                        color: Colors.orange,
//                        textColor: Colors.white,
//                        onPressed: () {
////                          editProfileBloc.updateProfile(_user);
//                        },
//                      ),
//                    ],
//                  ),
//                ),
//                const Opacity(
//                  opacity: 0.5,
//                  child: ModalBarrier(dismissible: false, color: Colors.grey),
//                ),
//                const Center(
//                  child: CircularProgressIndicator(),
//                ),
//              ],
//            ),
//          );
//        } else if (snapshot.hasData && snapshot.data is EditProfileFailure) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ編集',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: Center(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  const Text('ユーザー名'),
//                  Padding(
//                    padding: const EdgeInsets.all(16),
//                    child: TextField(
//                      onChanged: (String str) {
//                        editProfileBloc.name = str;
//                      },
//                      onSubmitted: (String str) {
//                        editProfileBloc.name = str;
//                      },
//                    ),
//                  ),
//                  const Text('一言'),
//                  Padding(
//                    padding: const EdgeInsets.all(16),
//                    child: TextField(
//                      onChanged: (String str) {
//                        editProfileBloc.introduction = str;
//                      },
//                      onSubmitted: (String str) {
//                        editProfileBloc.introduction = str;
//                      },
//                    ),
//                  ),
//                  RaisedButton(
//                    child: const Text('確定'),
//                    color: Colors.orange,
//                    textColor: Colors.white,
//                    onPressed: () {
////                      editProfileBloc.updateProfile(_user);
//                    },
//                  ),
//                ],
//              ),
//            ),
//          );
//        } else if (snapshot.hasData && snapshot.data is EditProfileSuccess) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ編集',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: Center(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  const Text('ユーザー名'),
//                  Padding(
//                    padding: const EdgeInsets.all(16),
//                    child: TextField(
//                      onChanged: (String str) {
//                        editProfileBloc.name = str;
//                      },
//                      onSubmitted: (String str) {
//                        editProfileBloc.name = str;
//                      },
//                    ),
//                  ),
//                  const Text('一言'),
//                  Padding(
//                    padding: const EdgeInsets.all(16),
//                    child: TextField(
//                      onChanged: (String str) {
//                        editProfileBloc.introduction = str;
//                      },
//                      onSubmitted: (String str) {
//                        editProfileBloc.introduction = str;
//                      },
//                    ),
//                  ),
//                  RaisedButton(
//                    child: const Text('確定'),
//                    color: Colors.orange,
//                    textColor: Colors.white,
//                    onPressed: () {
////                      editProfileBloc.updateProfile(_user);
//                    },
//                  ),
//                ],
//              ),
//            ),
//          );
//        } else {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ編集',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: Center(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Center(
//                    child: GestureDetector(
//                      child: Container(
//                        color: Colors.yellow,
//                        height: 200,
//                        width: 200,
//                        child: StreamBuilder(
//                          stream: editProfileBloc.selectedImage,
//                          builder: (context, snapshot) {
//                            if (snapshot.hasData && snapshot.data is Image) {
//                              return snapshot.data as Image;
//                            } else {
//                              return Text('no image');
//                            }
//                          },
//                        ),
//                      ),
////                      onTap: editProfileBloc.getImage,
//                    ),
//                  ),
//                  const Text('ユーザー名'),
//                  Padding(
//                    padding: const EdgeInsets.all(16),
//                    child: TextField(
//                      onChanged: (String str) {
//                        editProfileBloc.name = str;
//                      },
//                      onSubmitted: (String str) {
//                        editProfileBloc.name = str;
//                      },
//                    ),
//                  ),
//                  const Text('一言'),
//                  Padding(
//                    padding: const EdgeInsets.all(16),
//                    child: TextField(
//                      onChanged: (String str) {
//                        editProfileBloc.introduction = str;
//                      },
//                      onSubmitted: (String str) {
//                        editProfileBloc.introduction = str;
//                      },
//                    ),
//                  ),
//                  RaisedButton(
//                    child: const Text('確定'),
//                    color: Colors.orange,
//                    textColor: Colors.white,
//                    onPressed: () {
////                      editProfileBloc.updateProfile(_user);
//                    },
//                  ),
//                ],
//              ),
//            ),
//          );
//        }
//      },
//    );
  }
}

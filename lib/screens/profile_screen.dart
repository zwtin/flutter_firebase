import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/repositories/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/edit_profile_screen.dart';
import 'package:flutter_firebase/blocs/profile/profile_state.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(this.authenticationBloc)
      : assert(authenticationBloc != null);
  final AuthenticationBloc authenticationBloc;

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    return StreamBuilder<ProfileState>(
      stream: profileBloc.screenState,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is ProfileInProgress) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'マイページ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is ProfileFailure) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'マイページ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('読み込みに失敗しました'),
                  RaisedButton(
                    child: const Text('再読み込み'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: authenticationBloc.checkCurrentUser,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is ProfileSuccess) {
          return StreamBuilder(
            stream: (snapshot.data as ProfileSuccess).user,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'マイページ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () => showDialog<int>(
                        context: context,
                        builder: (_context) {
                          return SimpleDialog(
                            title: Text('タイトル'),
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(_context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute<EditProfileScreen>(
                                      builder: (context) {
                                        return BlocProvider<EditProfileBloc>(
                                          creator: (__context, _bag) {
                                            return EditProfileBloc(
                                              FirestoreUserRepository(),
                                            );
                                          },
                                          child:
                                              EditProfileScreen(snapshot.data),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Text("プロフィール編集"),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(_context);
                                  authenticationBloc.signOut();
                                },
                                child: Text("ログアウト"),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(_context);
                                },
                                child: Text("キャンセル"),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  backgroundColor: Colors.orange,
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Text('ユーザー名：${snapshot.data.name}'),
                    Text('一言：${snapshot.data.introduction}'),
                    Flexible(
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(50),
                            child: AppBar(
                              elevation: 0,
                              backgroundColor: Colors.white10,
                              bottom: const TabBar(
                                tabs: <Widget>[
                                  Tab(text: 'LEFT'),
                                  Tab(text: 'RIGHT'),
                                ],
                              ),
                            ),
                          ),
                          body: const TabBarView(
                            children: <Widget>[
                              Center(
                                child: Text('LEFT'),
                              ),
                              Center(
                                child: Text('RIGHT'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
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
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

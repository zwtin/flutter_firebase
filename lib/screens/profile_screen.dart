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
              title: const Text(
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
              title: const Text(
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
                  title: const Text(
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
                            title: const Text('タイトル'),
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
                                child: const Text('プロフィール編集'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(_context);
                                  authenticationBloc.signOut();
                                },
                                child: const Text('ログアウト'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(_context);
                                },
                                child: const Text('キャンセル'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  backgroundColor: Colors.orange,
                ),
                body: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
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
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: snap.data.toString(),
                                    );
                                  },
                                ),
                              ),
                              Center(
                                child: Text('ユーザー名：${snapshot.data.name}'),
                              ),
                              Center(
                                child: Text('一言：${snapshot.data.introduction}'),
                              ),
                            ],
                          ),
                        ),
                        const SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyTabBarDelegate(
                            TabBar(
                              tabs: <Widget>[
                                Tab(
                                  text: 'LEFT',
                                ),
                                Tab(
                                  text: 'RIGHT',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: <Widget>[
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Padding(
                                child: Text(
                                  '$index',
                                  style: const TextStyle(fontSize: 22),
                                ),
                                padding: const EdgeInsets.all(20),
                              ),
                            );
                          },
                          itemCount: 10,
                        ),
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Padding(
                                child: Text(
                                  '$index',
                                  style: const TextStyle(fontSize: 22),
                                ),
                                padding: const EdgeInsets.all(20),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
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

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: const Color(0xFFFAFAFA), child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

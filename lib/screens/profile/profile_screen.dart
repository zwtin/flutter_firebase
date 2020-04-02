import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/edit_profile/edit_profile_screen.dart';
import 'package:flutter_firebase/blocs/profile/profile_state.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';
import 'package:flutter_firebase/screens/event_detail/event_detail_screen.dart';
import 'package:flutter_firebase/models/firestore_event_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(this._signInBloc) : assert(_signInBloc != null);
  final SignInBloc _signInBloc;

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
                    onPressed: _signInBloc.checkCurrentUser,
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
                                  _signInBloc.signOut();
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
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverTabBarDelegate(
                            tabBar: const TabBar(
                              unselectedLabelColor: Colors.grey,
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
                              child: InkWell(
                                onTap: () {
//                                  Navigator.of(context).push(
//                                    MaterialPageRoute<EventDetailScreen>(
//                                      builder: (context) {
//                                        return BlocProvider<EventDetailBloc>(
//                                          creator: (_context, _bag) {
//                                            return EventDetailBloc(
//                                              snapshot.data.postedItems
//                                                  .elementAt(index),
//                                              FirestoreEventListRepository(),
//                                            );
//                                          },
//                                          child: EventDetailScreen(),
//                                        );
//                                      },
//                                    ),
//                                  );
                                },
                                child: Padding(
                                  child: Text(
//                                    '${snapshot.data.postedItems.elementAt(index)}',
                                    '$index',
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                ),
                              ),
                            );
                          },
//                          itemCount: snapshot.data.postedItems.length,
                        ),
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
//                                  Navigator.of(context).push(
//                                    MaterialPageRoute<EventDetailScreen>(
//                                      builder: (context) {
//                                        return BlocProvider<EventDetailBloc>(
//                                          creator: (_context, _bag) {
//                                            return EventDetailBloc(
//                                              snapshot.data.favoriteItems
//                                                  .elementAt(index),
//                                              FirestoreEventListRepository(),
//                                            );
//                                          },
//                                          child: EventDetailScreen(),
//                                        );
//                                      },
//                                    ),
//                                  );
                                },
                                child: Padding(
                                  child: Text(
//                                    '${snapshot.data.favoriteItems.elementAt(index)}',
                                    '$index',
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                ),
                              ),
                            );
                          },
//                          itemCount: snapshot.data.favoriteItems.length,
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

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  SliverTabBarDelegate({@required this.tabBar}) : assert(tabBar != null);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xFFFAFAFA),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

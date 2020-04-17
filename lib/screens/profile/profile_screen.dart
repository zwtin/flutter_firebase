import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/new_register/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_bloc.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/edit_profile/edit_profile_screen.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';
import 'package:flutter_firebase/screens/event_detail/event_detail_screen.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/screens/new_register/new_register_screen.dart';
import 'package:flutter_firebase/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_firebase/screens/sign_up/sign_up_screen.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/models/firestore_favorite_repository.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final profileBloc = Provider.of<ProfileBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    rootTransitionSubscription?.cancel();
    rootTransitionSubscription = tabBloc.rootTransitionController.stream.listen(
      (int index) {
        if (index == 1) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        if (index == 1) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<NewRegisterScreen>(
              builder: (BuildContext context) {
                return Provider<NewRegisterBloc>(
                  create: (BuildContext context) {
                    return NewRegisterBloc(
                      FirebaseAuthenticationRepository(),
                    );
                  },
                  dispose: (BuildContext context, NewRegisterBloc bloc) {
                    bloc.dispose();
                  },
                  child: NewRegisterScreen(),
                );
              },
              fullscreenDialog: true,
            ),
          );
        }
      },
    );

    return StreamBuilder(
      stream: profileBloc.currentUserController.stream,
      builder: (BuildContext context,
          AsyncSnapshot<CurrentUser> currentUserSnapshot) {
        if (currentUserSnapshot.hasData) {
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
                        title: const Text('タイトル'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(_context);
                              Navigator.of(context).push(
                                MaterialPageRoute<EditProfileScreen>(
                                  builder: (context) {
                                    return Provider<EditProfileBloc>(
                                      create: (__context) {
                                        return EditProfileBloc(
                                          FirestoreUserRepository(),
                                          FirebaseAuthenticationRepository(),
                                        );
                                      },
                                      dispose: (context, bloc) {
                                        bloc.dispose();
                                      },
                                      child: EditProfileScreen(),
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
                              profileBloc.signOut();
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
            body: StreamBuilder(
              stream: profileBloc.userController.stream,
              builder:
                  (BuildContext context, AsyncSnapshot<User> userSnapshot) {
                if (userSnapshot.hasData) {
                  return DefaultTabController(
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
                                        .child(userSnapshot.data.imageUrl)
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
                                  child:
                                      Text('ユーザー名：${userSnapshot.data.name}'),
                                ),
                                Center(
                                  child: Text(
                                      '一言：${userSnapshot.data.introduction}'),
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
                                    text: '投稿した記事',
                                  ),
                                  Tab(
                                    text: 'お気に入り記事',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: <Widget>[
                          StreamBuilder(
                            stream: profileBloc.createItemsController.stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Item>> snapshot) {
                              return ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<EventDetailScreen>(
                                            builder: (context) {
                                              return Provider<EventDetailBloc>(
                                                create: (__context) {
                                                  return EventDetailBloc(
                                                    snapshot.data
                                                        .elementAt(index)
                                                        .id,
                                                    FirestoreItemRepository(),
                                                    FirestoreLikeRepository(),
                                                    FirestoreFavoriteRepository(),
                                                    FirebaseAuthenticationRepository(),
                                                  );
                                                },
                                                dispose: (context, bloc) {
                                                  bloc.dispose();
                                                },
                                                child: EventDetailScreen(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        child: Text(
                                          '${snapshot.data.elementAt(index).id}',
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                      ),
                                    ),
                                  );
                                },
                                itemCount:
                                    snapshot.hasData ? snapshot.data.length : 0,
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: profileBloc.favoriteItemsController.stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Item>> snapshot) {
                              return ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<EventDetailScreen>(
                                            builder: (context) {
                                              return Provider<EventDetailBloc>(
                                                create: (__context) {
                                                  return EventDetailBloc(
                                                    snapshot.data
                                                        .elementAt(index)
                                                        .id,
                                                    FirestoreItemRepository(),
                                                    FirestoreLikeRepository(),
                                                    FirestoreFavoriteRepository(),
                                                    FirebaseAuthenticationRepository(),
                                                  );
                                                },
                                                dispose: (context, bloc) {
                                                  bloc.dispose();
                                                },
                                                child: EventDetailScreen(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        child: Text(
                                          '${snapshot.data.elementAt(index).id}',
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                      ),
                                    ),
                                  );
                                },
                                itemCount:
                                    snapshot.hasData ? snapshot.data.length : 0,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
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
            backgroundColor: Colors.orange,
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  child: const Text('ログイン'),
                  color: Colors.orange,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<SignInScreen>(
                        builder: (context) => Provider<SignInBloc>(
                          create: (context) {
                            return SignInBloc(
                              FirebaseAuthenticationRepository(),
                            );
                          },
                          dispose: (context, bloc) {
                            bloc.dispose();
                          },
                          child: SignInScreen(),
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: const Text('新規会員登録'),
                  color: Colors.orange,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<SignUpScreen>(
                        builder: (context) => Provider<SignUpBloc>(
                          create: (context) {
                            return SignUpBloc(
                              FirebaseAuthenticationRepository(),
                            );
                          },
                          dispose: (context, bloc) {
                            bloc.dispose();
                          },
                          child: SignUpScreen(),
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
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

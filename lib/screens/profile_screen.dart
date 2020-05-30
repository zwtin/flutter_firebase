import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/profile_bloc.dart';
import 'package:flutter_firebase/blocs/sign_up_bloc.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/entities/answer.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firebase_storage_repository.dart';
import 'package:flutter_firebase/models/firestore_answer_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/models/firestore_topic_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/edit_profile_screen.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/blocs/edit_profile_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase/blocs/event_detail_bloc.dart';
import 'package:flutter_firebase/screens/event_detail_screen.dart';
import 'package:flutter_firebase/screens/new_register_screen.dart';
import 'package:flutter_firebase/screens/sign_in_screen.dart';
import 'package:flutter_firebase/screens/sign_up_screen.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/models/firestore_favorite_repository.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileBloc = Provider.of<ProfileBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    profileBloc.rootTransitionSubscription?.cancel();
    profileBloc.rootTransitionSubscription =
        tabBloc.rootTransitionController.stream.listen(
      (int index) {
        if (index == 1) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

    profileBloc.popTransitionSubscription?.cancel();
    profileBloc.popTransitionSubscription =
        tabBloc.popTransitionController.stream.listen(
      (int index) {
        if (index == 1) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            tabBloc.indexController.sink.add(0);
          }
        }
      },
    );

    profileBloc.newRegisterSubscription?.cancel();
    profileBloc.newRegisterSubscription =
        tabBloc.newRegisterController.stream.listen(
      (int index) {
        if (index == 1) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<NewRegisterScreen>(
              builder: (BuildContext context) {
                return MultiProvider(
                  providers: [
                    Provider<NewRegisterBloc>(
                      create: (BuildContext context) {
                        return NewRegisterBloc(
                          FirebaseAuthenticationRepository(),
                          FirestoreUserRepository(),
                          FirestorePushNotificationRepository(),
                        );
                      },
                      dispose: (BuildContext context, NewRegisterBloc bloc) {
                        bloc.dispose();
                      },
                    ),
                    Provider<TabBloc>.value(value: tabBloc),
                  ],
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
      stream: profileBloc.userController.stream,
      builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
        if (userSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'マイページ',
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () => showDialog<int>(
                    context: context,
                    builder: (BuildContext _context) {
                      return SimpleDialog(
                        title: const Text('タイトル'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(_context);
                              Navigator.of(context).push(
                                MaterialPageRoute<EditProfileScreen>(
                                  builder: (BuildContext context) {
                                    return Provider<EditProfileBloc>(
                                      create: (BuildContext context) {
                                        return EditProfileBloc(
                                          FirestoreUserRepository(),
                                          FirebaseAuthenticationRepository(),
                                          FirebaseStorageRepository(),
                                        );
                                      },
                                      dispose: (BuildContext context,
                                          EditProfileBloc bloc) {
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
                          Container(
                            width: 128,
                            height: 128,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              imageUrl: userSnapshot.data.imageUrl,
                              errorWidget: (context, url, dynamic error) =>
                                  Image.asset('assets/icon/no_user.jpg'),
                            ),
                          ),
                          Center(
                            child: Text('ユーザー名：${userSnapshot.data.name}'),
                          ),
                          Center(
                            child: Text('一言：${userSnapshot.data.introduction}'),
                          ),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverTabBarDelegate(
                        tabBar: const TabBar(
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.black,
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
                      stream: profileBloc.createAnswersController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Answer>> snapshot) {
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<EventDetailScreen>(
                                      builder: (BuildContext context) {
                                        return Provider<EventDetailBloc>(
                                          create: (BuildContext context) {
                                            return EventDetailBloc(
                                              snapshot.data.elementAt(index),
                                              FirestoreLikeRepository(),
                                              FirestoreFavoriteRepository(),
                                              FirebaseAuthenticationRepository(),
                                            );
                                          },
                                          dispose: (BuildContext context,
                                              EventDetailBloc bloc) {
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
                      stream: profileBloc.favoriteAnswersController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Answer>> snapshot) {
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<EventDetailScreen>(
                                      builder: (BuildContext context) {
                                        return Provider<EventDetailBloc>(
                                          create: (BuildContext context) {
                                            return EventDetailBloc(
                                              snapshot.data.elementAt(index),
                                              FirestoreLikeRepository(),
                                              FirestoreFavoriteRepository(),
                                              FirebaseAuthenticationRepository(),
                                            );
                                          },
                                          dispose: (BuildContext context,
                                              EventDetailBloc bloc) {
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
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'マイページ',
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
          body: Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  child: const Text('ログイン'),
                  color: const Color(0xFFFFCC00),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<SignInScreen>(
                        builder: (BuildContext context) {
                          return MultiProvider(
                            providers: [
                              Provider<SignInBloc>(
                                create: (BuildContext context) {
                                  return SignInBloc(
                                    FirebaseAuthenticationRepository(),
                                    FirestoreUserRepository(),
                                    FirestorePushNotificationRepository(),
                                  );
                                },
                                dispose:
                                    (BuildContext context, SignInBloc bloc) {
                                  bloc.dispose();
                                },
                              ),
                              Provider<TabBloc>.value(value: tabBloc),
                            ],
                            child: SignInScreen(),
                          );
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: const Text('新規会員登録'),
                  color: const Color(0xFFFFCC00),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<SignUpScreen>(
                        builder: (BuildContext context) {
                          return MultiProvider(
                            providers: [
                              Provider<SignUpBloc>(
                                create: (BuildContext context) {
                                  return SignUpBloc(
                                    FirebaseAuthenticationRepository(),
                                    FirestoreUserRepository(),
                                    FirestorePushNotificationRepository(),
                                  );
                                },
                                dispose:
                                    (BuildContext context, SignUpBloc bloc) {
                                  bloc.dispose();
                                },
                              ),
                              Provider<TabBloc>.value(value: tabBloc),
                            ],
                            child: SignUpScreen(),
                          );
                        },
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
      color: const Color(0xFFFAFAFA),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

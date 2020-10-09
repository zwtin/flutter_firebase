import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/profile_bloc.dart';
import 'package:flutter_firebase/blocs/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/my_profile_bloc.dart';
import 'package:flutter_firebase/blocs/sign_up_bloc.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/models/firestore_sample_repository.dart';
import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firebase_storage_repository.dart';
import 'package:flutter_firebase/models/firestore_answer_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/models/firestore_topic_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/edit_profile_screen.dart';
import 'package:flutter_firebase/use_cases/user.dart';
import 'package:flutter_firebase/blocs/edit_profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase/blocs/event_detail_bloc.dart';
import 'package:flutter_firebase/screens/event_detail_screen.dart';
import 'package:flutter_firebase/screens/new_register_screen.dart';
import 'package:flutter_firebase/screens/profile_screen.dart';
import 'package:flutter_firebase/screens/sign_in_screen.dart';
import 'package:flutter_firebase/screens/sign_up_screen.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/models/firestore_favorite_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/common/string_extension.dart';
import 'package:flutter_firebase/blocs/image_detail_bloc.dart';
import 'package:flutter_firebase/screens/image_detail_screen.dart';
import 'package:tuple/tuple.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // blocを取得
    final myProfileBloc = Provider.of<MyProfileBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    // blocのstreamを購読

    // ルート画面に戻るイベントを購読
    myProfileBloc.rootTransitionSubscription?.cancel();
    myProfileBloc.rootTransitionSubscription =
        tabBloc.rootTransitionController.stream.listen(
      (int index) {
        if (index == 1) {
          // 選択タブが1のときしか反応しない
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

    // 戻るイベントを購読
    myProfileBloc.popTransitionSubscription?.cancel();
    myProfileBloc.popTransitionSubscription =
        tabBloc.popTransitionController.stream.listen(
      (int index) {
        if (index == 1) {
          // 選択タブが1のときしか反応しない
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            tabBloc.indexController.sink.add(0);
          }
        }
      },
    );

    // 新規会員登録イベントを購読
    myProfileBloc.newRegisterSubscription?.cancel();
    myProfileBloc.newRegisterSubscription =
        tabBloc.newRegisterController.stream.listen(
      (int index) {
        if (index == 1) {
          // 選択タブが1のときしか反応しない
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<NewRegisterScreen>(
              builder: (BuildContext context) {
                // 複数Providerを提供
                return MultiProvider(
                  providers: [
                    // NewRegisterBlocを提供
                    Provider<NewRegisterBloc>(
                      create: (BuildContext context) {
                        return NewRegisterBloc(
                          FirebaseAuthenticationRepository(),
                          FirestoreUserRepository(),
                          FirestorePushNotificationRepository(),
                        );
                      },

                      // 画面破棄時
                      dispose: (BuildContext context, NewRegisterBloc bloc) {
                        bloc.dispose();
                      },
                    ),

                    // 既存のTabBlocを提供
                    Provider<TabBloc>.value(value: tabBloc),
                  ],

                  // 表示画面
                  child: NewRegisterScreen(),
                );
              },
              fullscreenDialog: true,
            ),
          );
        }
      },
    );

    // Streamを監視するWidget
    return StreamBuilder(
      // 監視するStream
      stream: myProfileBloc.userController.stream,

      // イベントを検知したときに返す中身
      builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
        if (userSnapshot.hasData) {
          // データがある時
          return Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: Text(
                'マイページ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // 影をなくす
              bottom: PreferredSize(
                child: Container(
                  color: Colors.white24,
                  height: 1,
                ),
                preferredSize: const Size.fromHeight(1),
              ),

              // ナビゲーションバーの右上のボタン
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
                              myProfileBloc.signOut();
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

            // タブ画面
            body: DefaultTabController(
              // タブ数
              length: 2,

              // タブ画面を内包した、スクロールで隠れる画面
              child: NestedScrollView(
                // スクロールで隠れる画面
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    // Sliverの配列である必要がある
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            color: const Color(0xFFFFCC00),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute<ImageDetailScreen>(
                                          builder: (BuildContext context) {
                                            return Provider<ImageDetailBloc>(
                                              create: (BuildContext context) {
                                                return ImageDetailBloc(
                                                  userSnapshot.data.imageUrl,
                                                );
                                              },
                                              dispose: (BuildContext context,
                                                  ImageDetailBloc bloc) {
                                                bloc.dispose();
                                              },
                                              child: ImageDetailScreen(),
                                            );
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 128,
                                        height: 128,
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          imageUrl: userSnapshot.data.imageUrl,
                                          errorWidget: (context, url,
                                                  dynamic error) =>
                                              Image.asset(
                                                  'assets/icon/no_user.jpg'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            userSnapshot.data.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            userSnapshot.data.introduction,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sliverに準拠した、タブ切り替え部分
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverTabBarDelegate(
                        tabBar: const TabBar(
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.black,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                '投稿した記事',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'お気に入り記事',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },

                // タブ画面
                body: TabBarView(
                  children: <Widget>[
                    // タブ0: リフレッシュスクロール画面
                    RefreshIndicator(
                      color: const Color(0xFFFFCC00),

                      // 引き下げて更新時
                      onRefresh: myProfileBloc.userCreateAnswerControllerReset,

                      // 表示画面
                      child: Scrollbar(
                        // Streamを監視するWidget
                        child: StreamBuilder(
                          // 監視するStream
                          stream:
                              myProfileBloc.userCreateAnswersController.stream,

                          // イベントを検知したときに返す中身
                          builder: (BuildContext context,
                              AsyncSnapshot<Tuple2<List<Answer>, bool>>
                                  snapshot) {
                            return Container(
                              color: const Color(0xFFFFCC00),

                              // リスト表示
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == snapshot.data.item1.length) {
                                    return Container(
                                      height: 100,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  }
                                  return Card(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<EventDetailScreen>(
                                            builder: (BuildContext context) {
                                              return Provider<EventDetailBloc>(
                                                create: (BuildContext context) {
                                                  return EventDetailBloc(
                                                    snapshot.data.item1
                                                        .elementAt(index),
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: 16,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                width: 16,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute<
                                                        ProfileScreen>(
                                                      builder: (BuildContext
                                                          context) {
                                                        return Provider<
                                                            ProfileBloc>(
                                                          create: (BuildContext
                                                              context) {
                                                            return ProfileBloc(
                                                              snapshot
                                                                  .data.item1
                                                                  .elementAt(
                                                                      index)
                                                                  .topicCreatedUserId,
                                                              FirestoreUserRepository(),
                                                              FirestoreAnswerRepository(),
                                                              FirestoreTopicRepository(),
                                                              FirestoreSampleRepository(),
                                                            );
                                                          },
                                                          dispose: (BuildContext
                                                                  context,
                                                              ProfileBloc
                                                                  bloc) {
                                                            bloc.dispose();
                                                          },
                                                          child:
                                                              ProfileScreen(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    ClipOval(
                                                      child: SizedBox(
                                                        width: 44,
                                                        height: 44,
                                                        child:
                                                            CachedNetworkImage(
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          imageUrl: snapshot
                                                              .data.item1
                                                              .elementAt(index)
                                                              .topicCreatedUserImageUrl,
                                                          errorWidget: (context,
                                                                  url,
                                                                  dynamic
                                                                      error) =>
                                                              Image.asset(
                                                                  'assets/icon/no_image.jpg'),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            '${StringExtension.getJPStringFromDateTime(snapshot.data.item1.elementAt(index).topicCreatedAt)}'),
                                                        Text(
                                                            '${snapshot.data.item1.elementAt(index).topicCreatedUserName} さんからのお題：'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data.item1
                                                    .elementAt(index)
                                                    .topicText,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                          snapshot.data.item1
                                                  .elementAt(index)
                                                  .topicImageUrl
                                                  .isEmpty
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 16),
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    imageUrl: snapshot
                                                        .data.item1
                                                        .elementAt(index)
                                                        .topicImageUrl,
                                                    errorWidget: (context, url,
                                                            dynamic error) =>
                                                        Image.asset(
                                                            'assets/icon/no_image.jpg'),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.item2
                                    ? snapshot.data.item1.length + 1
                                    : snapshot.data.item1.length,
                                controller: myProfileBloc
                                    .userCreateAnswerScrollController,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // タブ1: リフレッシュスクロール画面
                    RefreshIndicator(
                      color: const Color(0xFFFFCC00),

                      // 引き下げて更新時
                      onRefresh: myProfileBloc.userFavorAnswerControllerReset,

                      // 表示画面
                      child: Scrollbar(
                        // Streamを監視するWidget
                        child: StreamBuilder(
                          // 監視するStream
                          stream:
                              myProfileBloc.userFavorAnswersController.stream,

                          // イベントを検知したときに返す中身
                          builder: (BuildContext context,
                              AsyncSnapshot<Tuple2<List<Answer>, bool>>
                                  snapshot) {
                            return Container(
                              color: const Color(0xFFFFCC00),

                              // リスト表示
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == snapshot.data.item1.length) {
                                    return Container(
                                      height: 100,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  }
                                  return Card(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<EventDetailScreen>(
                                            builder: (BuildContext context) {
                                              return Provider<EventDetailBloc>(
                                                create: (BuildContext context) {
                                                  return EventDetailBloc(
                                                    snapshot.data.item1
                                                        .elementAt(index),
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: 16,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                width: 16,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute<
                                                        ProfileScreen>(
                                                      builder: (BuildContext
                                                          context) {
                                                        return Provider<
                                                            ProfileBloc>(
                                                          create: (BuildContext
                                                              context) {
                                                            return ProfileBloc(
                                                              snapshot
                                                                  .data.item1
                                                                  .elementAt(
                                                                      index)
                                                                  .topicCreatedUserId,
                                                              FirestoreUserRepository(),
                                                              FirestoreAnswerRepository(),
                                                              FirestoreTopicRepository(),
                                                              FirestoreSampleRepository(),
                                                            );
                                                          },
                                                          dispose: (BuildContext
                                                                  context,
                                                              ProfileBloc
                                                                  bloc) {
                                                            bloc.dispose();
                                                          },
                                                          child:
                                                              ProfileScreen(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    ClipOval(
                                                      child: SizedBox(
                                                        width: 44,
                                                        height: 44,
                                                        child:
                                                            CachedNetworkImage(
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          imageUrl: snapshot
                                                              .data.item1
                                                              .elementAt(index)
                                                              .topicCreatedUserImageUrl,
                                                          errorWidget: (context,
                                                                  url,
                                                                  dynamic
                                                                      error) =>
                                                              Image.asset(
                                                                  'assets/icon/no_image.jpg'),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            '${StringExtension.getJPStringFromDateTime(snapshot.data.item1.elementAt(index).topicCreatedAt)}'),
                                                        Text(
                                                            '${snapshot.data.item1.elementAt(index).topicCreatedUserName} さんからのお題：'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data.item1
                                                    .elementAt(index)
                                                    .topicText,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                          snapshot.data.item1
                                                  .elementAt(index)
                                                  .topicImageUrl
                                                  .isEmpty
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 16),
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    imageUrl: snapshot
                                                        .data.item1
                                                        .elementAt(index)
                                                        .topicImageUrl,
                                                    errorWidget: (context, url,
                                                            dynamic error) =>
                                                        Image.asset(
                                                            'assets/icon/no_image.jpg'),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.item2
                                    ? snapshot.data.item1.length + 1
                                    : snapshot.data.item1.length,
                                controller: myProfileBloc
                                    .userFavorAnswerScrollController,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // データが無い時
        return Scaffold(
          // ナビゲーションバー
          appBar: AppBar(
            title: Text(
              'マイページ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFFCC00),
            elevation: 0, // 影をなくす
            bottom: PreferredSize(
              child: Container(
                color: Colors.white24,
                height: 1,
              ),
              preferredSize: const Size.fromHeight(1),
            ),
          ),

          // 本体
          body: Center(
            child: Column(
              children: <Widget>[
                // ボタン0
                RaisedButton(
                  child: const Text('ログイン'),
                  color: const Color(0xFFFFCC00),
                  textColor: Colors.white,
                  onPressed: () {
                    // ボタン押下時
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<SignInScreen>(
                        builder: (BuildContext context) {
                          // 複数のProviderを提供
                          return MultiProvider(
                            providers: [
                              // SignInBlocを提供
                              Provider<SignInBloc>(
                                create: (BuildContext context) {
                                  return SignInBloc(
                                    FirebaseAuthenticationRepository(),
                                    FirestoreUserRepository(),
                                    FirestorePushNotificationRepository(),
                                  );
                                },

                                // 画面破棄時
                                dispose:
                                    (BuildContext context, SignInBloc bloc) {
                                  bloc.dispose();
                                },
                              ),

                              // 既存のTabBlocを提供
                              Provider<TabBloc>.value(value: tabBloc),
                            ],

                            // 表示画面
                            child: SignInScreen(),
                          );
                        },

                        // 全画面で表示
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),

                // ボタン1
                RaisedButton(
                  child: const Text('新規会員登録'),
                  color: const Color(0xFFFFCC00),
                  textColor: Colors.white,
                  onPressed: () {
                    // ボタン押下時
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<SignUpScreen>(
                        builder: (BuildContext context) {
                          // 複数のProviderを提供
                          return MultiProvider(
                            providers: [
                              // SignUpBlocを提供
                              Provider<SignUpBloc>(
                                create: (BuildContext context) {
                                  return SignUpBloc(
                                    FirebaseAuthenticationRepository(),
                                    FirestoreUserRepository(),
                                    FirestorePushNotificationRepository(),
                                  );
                                },

                                // 画面破棄時
                                dispose:
                                    (BuildContext context, SignUpBloc bloc) {
                                  bloc.dispose();
                                },
                              ),

                              // 既存のTabBlocを提供
                              Provider<TabBloc>.value(value: tabBloc),
                            ],

                            // 表示画面
                            child: SignUpScreen(),
                          );
                        },

                        // 全画面で表示
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
      color: const Color(0xFFFFCC00),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

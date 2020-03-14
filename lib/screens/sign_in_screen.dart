import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:flutter_firebase/repositories/firestore_event_list_repository.dart';
import 'package:flutter_firebase/screens/edit_profile_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder<AuthenticationState>(
      stream: authenticationBloc.screenState,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is AuthenticationInProgress) {
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
        } else if (snapshot.hasData && snapshot.data is AuthenticationFailure) {
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
        } else if (snapshot.hasData && snapshot.data is AuthenticationSuccess) {
          final user = (snapshot.data as AuthenticationSuccess).currentUser;
          if (user == null) {
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
                    const Text('メール'),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (String str) {
                          authenticationBloc.inputEmail = str;
                        },
                        onSubmitted: (String str) {
                          authenticationBloc.inputEmail = str;
                        },
                      ),
                    ),
                    const Text('パスワード'),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (String str) {
                          authenticationBloc.inputPassword = str;
                        },
                        onSubmitted: (String str) {
                          authenticationBloc.inputPassword = str;
                        },
                      ),
                    ),
                    RaisedButton(
                      child: const Text('ログイン'),
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: authenticationBloc.loginWithEmailAndPassword,
                    ),
                  ],
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
                                          FirestoreEventListRepository(),
                                        );
                                      },
                                      child: EditProfileScreen(),
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
                Image.asset('assets/icon/icon.png'),
                Text('ユーザー名：${user.id}'),
                Text('一言：${user.updatedAt}'),
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
        } else {
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
        }
      },
    );
  }
}

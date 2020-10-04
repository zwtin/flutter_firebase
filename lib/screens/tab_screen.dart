import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // blocを取得
    final tabBloc = Provider.of<TabBloc>(context);

    // 戻るボタンのアクションを制御したいため、WillPopScopeでラップ
    return WillPopScope(
      // 戻るボタン押下時
      onWillPop: () {
        // 戻るアクション
        tabBloc.popAction();
        // 標準の戻るアクションは発火させない
        return Future.value(false);
      },

      // Streamを監視するWidget
      child: StreamBuilder(
        // 監視するStream
        stream: tabBloc.indexController.stream,

        // イベントを検知したときに返す中身
        builder: (BuildContext context, AsyncSnapshot<int> indexSnapshot) {
          return Scaffold(
            // 下タブ設定
            bottomNavigationBar: FFNavigationBar(
              // 下タブのテーマ設定（色や影など）
              theme: FFNavigationBarTheme(
                barBackgroundColor: Colors.black87,
                selectedItemBackgroundColor: const Color(0xFFFFCC00),
                selectedItemLabelColor: Colors.white,
                selectedItemBorderColor: Colors.yellow,
                unselectedItemIconColor: Colors.grey,
                showSelectedItemShadow: false,
              ),

              // 選択されたタブのインデックス
              selectedIndex: indexSnapshot.data ?? 0,

              // タブ押下時
              onSelectTab: tabBloc.tabTappedAction,

              // タブの表示アイコン
              items: [
                FFNavigationBarItem(
                  iconData: Icons.home,
                  label: 'ホーム',
                ),
                FFNavigationBarItem(
                  iconData: Icons.person,
                  label: 'マイページ',
                ),
              ],
            ),

            // 表示画面
            body: IndexedStack(
              // 表示画面のインデックス
              index: indexSnapshot.data ?? 0,

              // 表示画面の配列
              children: <Widget>[
                tabBloc.tab0,
                tabBloc.tab1,
              ],
            ),
          );
        },
      ),
    );
  }
}

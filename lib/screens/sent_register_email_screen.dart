import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/blocs/sent_register_email_bloc.dart';

class SentRegisterEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sentRegisterEmailBloc = Provider.of<SentRegisterEmailBloc>(context);

// 画面
    return Scaffold(
// ナビゲーションバー
      appBar: AppBar(
        title: const Text(
          '新規会員登録',
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
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFFFCC00),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                '入力されたメールアドレスに確認メールをお送りしました。\n'
                'メール内のリンクからアプリを開き、新規会員登録を完了してください。',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/blocs/sent_register_email_bloc/sent_register_email_bloc.dart';

class SentRegisterEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sentRegisterEmailBloc = Provider.of<SentRegisterEmailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'メール送信完了',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text('メール送信完了'),
      ),
    );
  }
}

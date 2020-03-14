import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editProfileBloc = BlocProvider.of<EditProfileBloc>(context);

    return StreamBuilder<AuthenticationState>(
      stream: editProfileBloc.onAdd,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is AuthenticationInProgress) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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

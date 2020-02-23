import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';

class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventListBloc = BlocProvider.of<EventListBloc>(context);

    return StreamBuilder<EventListState>(
      stream: eventListBloc.onAdd,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is EventListInProgress) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'AppBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is EventListFailure) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'AppBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('no user login'),
                  RaisedButton(
                    child: const Text('Button'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () => eventListBloc.read.add(null),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'AppBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('no user login'),
                  RaisedButton(
                    child: const Text('Button'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () => eventListBloc.read.add(null),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

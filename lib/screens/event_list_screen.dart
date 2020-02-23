import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';
import 'package:flutter_firebase/blocs/event_list//event_list_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';

class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventListBloc = BlocProvider.of<EventListBloc>(context);

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
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Text(index.toString());
        },
      ),
    );

    /*

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
        } else if (snapshot.hasData && snapshot.data is EventListSuccess) {
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
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Text(index.toString());
              },
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
     */
    /*
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: SafeArea(
        child: BlocBuilder<EventListBloc, EventListState>(
          bloc: eventListBloc,
          builder: (context, state) {
            if (state is EventListInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is EventListSuccess) {
              return StreamBuilder(
                stream: state.eventList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[Text("Failure")],
                    ));
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final event = snapshot.data[index];
                          return Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                ListTile(
                                  title: Text(event.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(event.date.toIso8601String()),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Image.network(
                                      event.imageUrl,
                                      fit: BoxFit.none,
                                      height: 128,
                                    ))
                                  ],
                                ),
                                Text(event.description)
                              ]));
                        },
                        itemCount: snapshot.data.length,
                      )),
                      Flexible(
                        child: RaisedButton(
                          onPressed: () {
//                            authenticationBloc.add(LoggedOut());
                          },
                          child: Text('Sign out'),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            if (state is EventListFailure) {
              return Center(
                child: Text("Failure"),
              );
            }

            return Container();
          },
        ),
      ),
    );
    */
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_event.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:flutter_firebase/repositories/firestore_event_list_repository.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_event.dart';

class EventListScreen extends StatelessWidget {
  //ignore: close_sinks
  final AuthenticationBloc authenticationBloc;

  EventListScreen(
      {@required this.authenticationBloc}) :assert(authenticationBloc != null);

  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    final eventListBloc = EventListBloc(eventListRepository: FirestoreEventListRepository());

    eventListBloc.add(EventListLoad());

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
                            authenticationBloc.add(LoggedOut());
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
  }
}

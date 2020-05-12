import 'package:flutter_firebase/entities/topic.dart';
import 'package:flutter_firebase/entities/topic_entity.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PostTopicSelectBloc {
  PostTopicSelectBloc(
    this._topicRepository,
    this._userRepository,
  )   : assert(_topicRepository != null),
        assert(_userRepository != null) {
    start();
  }

  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  final BehaviorSubject<List<Topic>> topicController =
      BehaviorSubject<List<Topic>>.seeded([]);

  Future<void> start() async {
    try {
      final topicEntities = await _topicRepository.getTopicList();
      List<Topic> topics = [];
      for (var topicEntity in topicEntities) {
        final userId = topicEntity.createdUser;
        final createdUser = await _userRepository.getUser(userId: userId);
        topics.add(
          Topic(
            id: topicEntity.id,
            text: topicEntity.text,
            imageUrl: topicEntity.imageUrl,
            createdAt: topicEntity.createdAt,
            createdUserId: topicEntity.createdUser,
            createdUserName: createdUser.name,
            createdUserImageUrl: createdUser.imageUrl,
          ),
        );
      }
      ;
      topicController.sink.add(topics);
    } on Exception catch (error) {
      return;
    }
  }

  String getJPStringFromDateTime(DateTime dateTime) {
    initializeDateFormatting('ja_JP');
    final formatter = DateFormat('yyyy/MM/dd(E) HH:mm', 'ja_JP');
    final formatted = formatter.format(dateTime); // DateからString
    return formatted;
  }

  Future<void> dispose() async {
    await topicController.close();
  }
}

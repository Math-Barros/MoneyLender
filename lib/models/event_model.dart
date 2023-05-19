import 'package:moneylender/models/friend_model.dart';

class EventModel {
  final String id;
  final String eventName;
  final String eventDescription;
  final List<FriendModel> invitedFriends;

  const EventModel({
    required this.id,
    required this.eventName,
    required this.eventDescription,
    required this.invitedFriends,
  });
}

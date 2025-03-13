import 'package:flutter/material.dart';
import 'friend_request_tile.dart';

class FriendRequestList extends StatelessWidget {
  final List<String> friendRequests;
  final Function(String) onAccept;
  final Function(String) onDecline;

  const FriendRequestList({
    super.key,
    required this.friendRequests,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: friendRequests.map((requestUserId) {
        return FriendRequestTile(
          requestUserId: requestUserId,
          onAccept: onAccept,
          onDecline: onDecline,
        );
      }).toList(),
    );
  }
}
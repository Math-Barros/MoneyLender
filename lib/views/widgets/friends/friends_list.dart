import 'package:flutter/material.dart';
import 'friend_tile.dart';

class FriendsList extends StatelessWidget {
  final List<String> friends;
  final Function(String) onRemove;

  const FriendsList({
    super.key,
    required this.friends,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: friends.map((friendUserId) {
        return FriendTile(
          friendUserId: friendUserId,
          onRemove: onRemove,
        );
      }).toList(),
    );
  }
}
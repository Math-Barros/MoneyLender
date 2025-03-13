import 'package:flutter/material.dart';
import '../models/friend_model.dart';

class FriendController {
  final FriendModel friendModel;
  final BuildContext context;

  FriendController(this.context, this.friendModel);

  Future<void> handleAddFriend(String friendEmailToAdd) async {
    if (friendEmailToAdd.isNotEmpty) {
      await friendModel.sendFriendRequest(friendEmailToAdd);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação de amizade enviada!')),
      );
    }
  }

  Future<void> handleAcceptFriendRequest(String requestId) async {
    await friendModel.acceptFriendRequest(requestId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amizade aceita com sucesso!')),
    );
  }

  Future<void> handleDeclineFriendRequest(String requestId) async {
    await friendModel.declineFriendRequest(requestId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitação de amizade recusada.')),
    );
  }

  Future<void> handleRemoveFriend(String friendUserId) async {
    await friendModel.removeFriend(friendUserId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amigo removido com sucesso!')),
    );
  }
}

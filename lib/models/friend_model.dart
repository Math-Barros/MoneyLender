import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  final String userId;

  FriendModel(this.userId);

  Future<List<String>> getFriends() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data();
    if (data != null && data['friends'] != null && data['friends'] is List) {
      return List<String>.from(data['friends']);
    }
    return [];
  }

  Future<List<String>> getFriendRequests() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data();
    if (data != null && data['friendRequests'] != null && data['friendRequests'] is List) {
      return List<String>.from(data['friendRequests']);
    }
    return [];
  }

  Future<void> sendFriendRequest(String friendEmailToAdd) async {
    final friendSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: friendEmailToAdd)
        .get();

    if (friendSnapshot.docs.isNotEmpty) {
      final friendId = friendSnapshot.docs[0].id;
      final friendRef = FirebaseFirestore.instance.collection('users').doc(friendId);

      await friendRef.update({
        'friendRequests': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    final currentUserRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final requestUserRef = FirebaseFirestore.instance.collection('users').doc(requestId);

    await currentUserRef.update({
      'friends': FieldValue.arrayUnion([requestId]),
      'friendRequests': FieldValue.arrayRemove([requestId]),
    });

    await requestUserRef.update({
      'friends': FieldValue.arrayUnion([userId]),
      'friendRequests': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> declineFriendRequest(String requestId) async {
    final currentUserRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await currentUserRef.update({
      'friendRequests': FieldValue.arrayRemove([requestId]),
    });
  }

  Future<void> removeFriend(String friendUserId) async {
    final currentUserRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final friendUserRef = FirebaseFirestore.instance.collection('users').doc(friendUserId);

    await currentUserRef.update({
      'friends': FieldValue.arrayRemove([friendUserId]),
    });

    await friendUserRef.update({
      'friends': FieldValue.arrayRemove([userId]),
    });
  }
}

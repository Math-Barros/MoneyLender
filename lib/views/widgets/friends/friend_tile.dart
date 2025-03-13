import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final String friendUserId;
  final Function(String) onRemove;

  const FriendTile({
    super.key,
    required this.friendUserId,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(friendUserId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Erro ao carregar os dados.');
        }

        final friendUserData = snapshot.data?.data() as Map<String, dynamic>;
        final friendEmail = friendUserData['email'];
        final friendName = friendUserData['name'];

        return ListTile(
          title: Text(friendName),
          subtitle: Text(friendEmail),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onRemove(friendUserId),
          ),
        );
      },
    );
  }
}
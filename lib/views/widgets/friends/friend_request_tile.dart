import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendRequestTile extends StatelessWidget {
  final String requestUserId;
  final Function(String) onAccept;
  final Function(String) onDecline;

  const FriendRequestTile({
    super.key,
    required this.requestUserId,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(requestUserId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Erro ao carregar os dados.');
        }

        final requestUserData = snapshot.data?.data() as Map<String, dynamic>;
        final requestEmail = requestUserData['email'];

        return ListTile(
          title: const Text('Solicitação de Amizade'),
          subtitle: Text('De: $requestEmail'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => onAccept(requestUserId),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onDecline(requestUserId),
              ),
            ],
          ),
        );
      },
    );
  }
}
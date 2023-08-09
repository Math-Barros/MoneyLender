import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FriendListScreen extends StatefulWidget {
  final String userId;

  const FriendListScreen({required this.userId});

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  List<String> friends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend List'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Ocorreu um erro ao carregar a lista de amigos.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final data = snapshot.data?.data();
          if (data == null || !data.containsKey('friends')) {
            return const Text('Nenhum amigo encontrado.');
          }

          friends = List<String>.from(data['friends']);

          if (friends.isEmpty) {
            return const Text('Nenhum amigo encontrado.');
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friendId = friends[index];

              return ListTile(
                title: Text('Friend $index'),
                subtitle: Text('Friend ID: $friendId'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeFriend(friendId),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Adicionar Amigo',
            onTap: _addFriend,
          ),
        ],
      ),
    );
  }

  void _addFriend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Amigo'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'ID do Amigo'),
          onChanged: (value) {
            // Implement the logic to store the friend's ID entered by the user
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final friendId =
                  ''; // Get the friend's ID entered in the text field

              if (friendId.isNotEmpty) {
                final userRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId);

                // Check if the friendId is a valid user in your system
                final friendSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(friendId)
                    .get();
                if (friendSnapshot.exists) {
                  await userRef.update({
                    'friendRequests': FieldValue.arrayUnion([friendId]),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Solicitação de amizade enviada!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('ID do amigo não encontrado.')),
                  );
                }
              }

              Navigator.of(context).pop();
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _removeFriend(String friendId) async {
    setState(() {
      friends.remove(friendId);
    });

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    await userRef.update({
      'friends': FieldValue.arrayRemove([friendId]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amigo removido com sucesso!')),
    );
  }
}

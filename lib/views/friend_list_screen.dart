import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FriendListScreen extends StatefulWidget {
  static const String id = '/friendList';

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
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
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

              // Aqui você pode recuperar as informações do amigo a partir do ID e exibi-las
              // Você pode fazer uma nova consulta ao Firestore usando o friendId para obter os dados do amigo

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
            // Implemente a lógica para armazenar o ID do amigo inserido
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
              final friendId = ''; // Obtenha o ID do amigo inserido no campo de texto

              if (friendId.isNotEmpty) {
                final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);

                await userRef.update({
                  'friends': FieldValue.arrayUnion([friendId]),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Amigo adicionado com sucesso!')),
                );
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

    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);

    await userRef.update({
      'friends': FieldValue.arrayRemove([friendId]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amigo removido com sucesso!')),
    );
  }
}

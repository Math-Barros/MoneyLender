import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:moneylender/views/home_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:moneylender/views/profile_screen.dart';

class FriendListScreen extends StatefulWidget {
  final String userId;

  const FriendListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  List<String> friends = [];
  int _selectedIndex = 2;
  late String friendEmailToAdd;

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
              final friendEmail = friends[index];

              return ListTile(
                title: Text('Friend $index'),
                subtitle: Text('Friend Email: $friendEmail'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeFriend(friendEmail),
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
            child: const Icon(Icons.add),
            label: 'Adicionar Amigo',
            onTap: _addFriend,
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
        color: Colors.grey[800]!,
        buttonBackgroundColor: Colors.grey[800]!,
        height: 50,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _navigateToHome(context);
            } else if (index == 1) {
              _navigateToProfile(context);
            }
          });
        },
        items: const <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
          Icon(Icons.people, color: Colors.white),
        ],
      ),
    );
  }

  void _sendFriendRequest(String friendEmailToAdd) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    final friendSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: friendEmailToAdd)
        .get();

    if (friendSnapshot.docs.isNotEmpty) {
      final friendId = friendSnapshot.docs[0].id;
      await userRef.update({
        'friendRequests': FieldValue.arrayUnion([friendId]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação de amizade enviada!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email do amigo não encontrado.')),
      );
    }
  }

  void _addFriend() {
    String friendEmailToAdd = '';

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Adicionar Amigo',
      desc: 'Insira o email do amigo',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            friendEmailToAdd = value;
          },
          decoration: const InputDecoration(
            labelText: 'Email do Amigo',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        if (friendEmailToAdd.isNotEmpty) {
          _sendFriendRequest(friendEmailToAdd);
        }
      },
    ).show();
  }

  void _removeFriend(String friendEmail) async {
    setState(() {
      friends.remove(friendEmail);
    });

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    await userRef.update({
      'friends': FieldValue.arrayRemove([friendEmail]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amigo removido com sucesso!')),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          user: FirebaseAuth.instance.currentUser!,
          googleSignIn: GoogleSignIn(),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          user: FirebaseAuth.instance.currentUser!,
          googleSignIn: GoogleSignIn(),
        ),
      ),
    );
  }
}

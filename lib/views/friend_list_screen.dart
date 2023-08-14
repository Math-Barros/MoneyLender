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
  List<String> friendRequests = [];
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
          if (data == null) {
            return const Text('Nenhum dado encontrado.');
          }

          final friendsData = data['friends'];
          if (friendsData != null && friendsData is List) {
            friends = List<String>.from(friendsData);
          }

          final requestsData = data['friendRequests'];
          if (requestsData != null && requestsData is List) {
            friendRequests = List<String>.from(requestsData);
          }

          return ListView(
            children: [
              const SizedBox(height: 16),
              if (friendRequests.isNotEmpty)
                ...friendRequests.map((requestUserId) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(requestUserId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Erro ao carregar os dados.');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final requestUserData =
                          snapshot.data?.data() as Map<String, dynamic>?;
                      if (requestUserData == null) {
                        return const SizedBox();
                      }

                      final requestEmail = requestUserData['email'] as String;

                      return ListTile(
                        title: Text('Friend Request'),
                        subtitle: Text('From: $requestEmail'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () =>
                                  _acceptFriendRequest(requestUserId),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () =>
                                  _declineFriendRequest(requestUserId),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              if (friends.isNotEmpty)
                ...friends.asMap().entries.map((entry) {
                  final index = entry.key;
                  final friendUserId = entry.value;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendUserId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Erro ao carregar os dados.');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final friendUserData =
                          snapshot.data?.data() as Map<String, dynamic>?;
                      if (friendUserData == null) {
                        return const SizedBox();
                      }

                      final friendEmail = friendUserData['email'] as String;

                      return ListTile(
                        title: Text('Friend $index'),
                        subtitle: Text('Friend Email: $friendEmail'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeFriend(friendUserId),
                        ),
                      );
                    },
                  );
                }).toList(),
            ],
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

  void _acceptFriendRequest(String requestId) async {
    final currentUserRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);
    final requestUserRef =
        FirebaseFirestore.instance.collection('users').doc(requestId);

    await currentUserRef.update({
      'friends': FieldValue.arrayUnion([requestId]),
      'friendRequests': FieldValue.arrayRemove([requestId]),
    });

    await requestUserRef.update({
      'friends': FieldValue.arrayUnion([widget.userId]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amizade aceita com sucesso!')),
    );
  }

  void _declineFriendRequest(String requestId) async {
    final currentUserRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    await currentUserRef.update({
      'friendRequests': FieldValue.arrayRemove([requestId]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitação de amizade recusada.')),
    );
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

  void _removeFriend(String friendUserId) async {
    final currentUserRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    await currentUserRef.update({
      'friends': FieldValue.arrayRemove([friendUserId]),
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

  void _sendFriendRequest(String friendEmailToAdd) async {
    final friendSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: friendEmailToAdd)
        .get();

    if (friendSnapshot.docs.isNotEmpty) {
      final friendId = friendSnapshot.docs[0].id;

      final friendRef =
          FirebaseFirestore.instance.collection('users').doc(friendId);

      await friendRef.update({
        'friendRequests': FieldValue.arrayUnion([widget.userId]),
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
}

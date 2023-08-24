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
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
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

          if (friendRequests.isNotEmpty) {
            return _buildFriendRequestList();
          } else if (friends.isNotEmpty) {
            return _buildFriendsList();
          } else {
            return _buildEmptyFriendsList();
          }
        },
      ),
      floatingActionButton: _buildSpeedDial(),
      bottomNavigationBar: _buildCurvedNavigationBar(),
    );
  }

  Widget _buildFriendRequestList() {
    return ListView(
      children: [
        const SizedBox(height: 16),
        ...friendRequests.map((requestUserId) {
          return _buildFriendRequestTile(requestUserId);
        }).toList(),
      ],
    );
  }

  Widget _buildFriendRequestTile(String requestUserId) {
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

        final requestUserData = snapshot.data?.data() as Map<String, dynamic>?;
        if (requestUserData == null) {
          return const SizedBox();
        }

        final requestEmail = requestUserData['email'] as String;

        return ListTile(
          title: const Text('Friend Request'),
          subtitle: Text('From: $requestEmail'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _acceptFriendRequest(requestUserId),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _declineFriendRequest(requestUserId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFriendsList() {
    return ListView(
      children: [
        const SizedBox(height: 16),
        ...friends.asMap().entries.map((entry) {
          final index = entry.key;
          final friendUserId = entry.value;

          return _buildFriendTile(friendUserId);
        }).toList(),
      ],
    );
  }

  Widget _buildFriendTile(String friendUserId) {
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

        final friendUserData = snapshot.data?.data() as Map<String, dynamic>?;
        if (friendUserData == null) {
          return const SizedBox();
        }

        final friendEmail = friendUserData['email'] as String;
        final friendName = friendUserData['name'] as String;

        return ListTile(
          title: Text(
            friendName,
            style: const TextStyle(
              color: Color(0xFFCBB26A),
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            friendEmail,
            style: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _removeFriend(friendUserId),
          ),
        );
      },
    );
  }

  Widget _buildEmptyFriendsList() {
    return const Center(
      child: Text(
        'Você não possui amigos.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Adicionar Amigo',
          onTap: _addFriend,
        ),
      ],
    );
  }

  Widget _buildCurvedNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      color: const Color(0xFFCBB26A),
      buttonBackgroundColor: const Color(0xFFCBB26A),
      height: 50,
      animationDuration: const Duration(milliseconds: 300),
      index: _selectedIndex,
      onTap: _onNavigationBarTap,
      items: const <Widget>[
        Icon(Icons.home, color: Color.fromRGBO(19, 42, 101, 1.0)),
        Icon(Icons.person, color: Color.fromRGBO(19, 42, 101, 1.0)),
        Icon(Icons.people, color: Color.fromRGBO(19, 42, 101, 1.0)),
      ],
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
      'friendRequests': FieldValue.arrayRemove([widget.userId]),
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
    final friendUserRef =
        FirebaseFirestore.instance.collection('users').doc(friendUserId);

    await currentUserRef.update({
      'friends': FieldValue.arrayRemove([friendUserId]),
    });

    await friendUserRef.update({
      'friends': FieldValue.arrayRemove([widget.userId]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Amigo removido com sucesso!')),
    );
  }

  void _onNavigationBarTap(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _navigateToHome(context);
      } else if (index == 1) {
        _navigateToProfile(context);
      }
    });
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

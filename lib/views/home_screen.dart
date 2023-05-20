import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/event_details_screen.dart';
import 'package:moneylender/views/add_event_screen.dart';
import 'package:moneylender/views/friend_list_screen.dart';
import 'package:moneylender/views/profile_screen.dart'; // Importe a classe ProfileScreen

class HomeScreen extends StatelessWidget {
  static const String id = '/home';

  final User? user;
  final GoogleSignIn googleSignIn;

  const HomeScreen({required this.user, required this.googleSignIn});

  void _handleSignOut(BuildContext context) async {
    if (user != null) {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      Navigator.pop(context);
    }
  }

  void _navigateToAddEvent(BuildContext context) {
    Navigator.pushNamed(context, AddEventScreen.id);
  }

  void _navigateToFriendList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FriendListScreen(userId: FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
            user: user,
            googleSignIn:
                googleSignIn), // Passe o objeto User e o GoogleSignIn para ProfileScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          const Text(
            'Meus Eventos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .where('creatorId', isEqualTo: user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Ocorreu um erro ao carregar os eventos.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final events = snapshot.data?.docs ?? [];

                if (events.isEmpty) {
                  return const Text('Nenhum evento encontrado.');
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index].data();

                    final eventName = event?['name']?.toString() ?? '';
                    final eventDescription =
                        event?['description']?.toString() ?? '';
                    final eventId = event?['eventId']?.toString() ?? '';

                    return ListTile(
                      title: Text(eventName),
                      subtitle: Text(eventDescription),
                      onTap: () => _navigateToEventDetails(context, eventId),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _navigateToAddEvent(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _navigateToProfile(
                context); // Navegue para ProfileScreen quando o índice for 1
          } else if (index == 2) {
            _navigateToFriendList(context);
          }
        },
      ),
    );
  }

  void _navigateToEventDetails(BuildContext context, String eventId) {
    Navigator.pushNamed(context, EventDetailsScreen.id, arguments: eventId);
  }
}

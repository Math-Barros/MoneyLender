import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/event_details_screen.dart';
import 'package:moneylender/views/add_event_screen.dart';
import 'package:moneylender/views/friend_list_screen.dart';
import 'package:moneylender/views/profile_screen.dart';

class HomeScreen extends StatelessWidget {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(user: user!),
      ),
    );
  }

  void _navigateToFriendList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendListScreen(userId: user!.uid),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfileScreen(user: user, googleSignIn: googleSignIn),
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
                  .collection('users')
                  .doc(user!.uid)
                  .collection('events')
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
                    final eventId = events[index].id; // Obtém o ID do documento

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
            _navigateToProfile(context);
          } else if (index == 2) {
            _navigateToFriendList(context);
          }
        },
      ),
    );
  }

  void _navigateToEventDetails(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(eventId: eventId, user: user!),
      ),
    );
  }
}

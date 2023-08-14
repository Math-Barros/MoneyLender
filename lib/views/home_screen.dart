import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:moneylender/views/event_details_screen.dart';
import 'package:moneylender/views/add_event_screen.dart';
import 'package:moneylender/views/friend_list_screen.dart';
import 'package:moneylender/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  final GoogleSignIn googleSignIn;

  const HomeScreen({Key? key, required this.user, required this.googleSignIn})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      body: Column(
        children: [
          const SizedBox(height: 50.0),
          const Text(
            'Meus Eventos',
            style: TextStyle(
              color: Color(0xFFCBB26A),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2.5),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user!.uid)
                  .collection('events')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Ocorreu um erro ao carregar os eventos.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  );
                }

                final events = snapshot.data?.docs ?? [];

                if (events.isEmpty) {
                  return const Text(
                    '             Nenhum evento encontrado.',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index].data();

                    final eventName = event['name']?.toString() ?? '';
                    final eventDescription =
                        event['description']?.toString() ?? '';
                    final eventId = events[index].id;

                    return ListTile(
                      title: Text(
                        eventName,
                        style: const TextStyle(
                          color: Color(0xFFCBB26A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        eventDescription,
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
        splashColor: const Color.fromRGBO(19, 42, 101, 1.0),
        backgroundColor: const Color(0xFFCBB26A),
        child: const Icon(Icons.add, color: Color.fromRGBO(19, 42, 101, 1.0)),
        onPressed: () => _navigateToAddEvent(context),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
        color: const Color(0xFFCBB26A),
        buttonBackgroundColor: const Color(0xFFCBB26A),
        height: 50,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              _navigateToProfile(context);
            } else if (index == 2) {
              _navigateToFriendList(context);
            }
          });
        },
        items: const <Widget>[
          Icon(Icons.home, color: Color.fromRGBO(19, 42, 101, 1.0)),
          Icon(Icons.person, color: Color.fromRGBO(19, 42, 101, 1.0)),
          Icon(Icons.people, color: Color.fromRGBO(19, 42, 101, 1.0)),
        ],
      ),
    );
  }

  void _navigateToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(user: widget.user!),
      ),
    );
  }

  void _navigateToFriendList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendListScreen(userId: widget.user!.uid),
      ),
    );
  }

  void _navigateToEventDetails(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EventDetailsScreen(eventId: eventId, user: widget.user!),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylender/views/friend_list_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String id = '/event_details';

  final String eventId;

  const EventDetailsScreen({required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Evento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID do Evento: $eventId',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _openFriendListScreen(context),
              child: const Text('Adicionar Amigo'),
            ),
          ],
        ),
      ),
    );
  }

  void _openFriendListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FriendListScreen(userId: FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }
}

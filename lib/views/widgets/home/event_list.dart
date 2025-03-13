import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/event_details_page.dart';

class EventList extends StatelessWidget {
  final User? user;

  const EventList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
            final eventDescription = event['description']?.toString() ?? '';
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
    );
  }

  void _navigateToEventDetails(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(
          eventId: eventId,
          userId: user!.uid,
        ),
      ),
    );
  }
}

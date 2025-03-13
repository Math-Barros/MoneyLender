import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneylender/views/add_event_page.dart';

class EventButton extends StatelessWidget {
  final User? user;

  const EventButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      splashColor: const Color.fromRGBO(19, 42, 101, 1.0),
      backgroundColor: const Color(0xFFCBB26A),
      child: const Icon(Icons.add, color: Color.fromRGBO(19, 42, 101, 1.0)),
      onPressed: () => _navigateToAddEvent(context),
    );
  }

  void _navigateToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventPage(user: user!),
      ),
    );
  }
}
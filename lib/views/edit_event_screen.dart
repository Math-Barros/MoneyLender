import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditEventScreen extends StatefulWidget {
  static const String id = '/edit_event';

  final String eventId;
  final String eventPassword;
  final User user;

  const EditEventScreen({
    required this.eventId,
    required this.eventPassword,
    required this.user,
  });

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  String _eventName = '';
  String _eventLocation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: _eventName, // Populate with initial event name
              decoration: InputDecoration(labelText: 'Nome do Evento'),
              onChanged: (value) {
                setState(() {
                  _eventName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: _eventLocation, // Populate with initial event location
              decoration: InputDecoration(labelText: 'Local do Evento'),
              onChanged: (value) {
                setState(() {
                  _eventLocation = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _updateEventDetails(context),
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateEventDetails(BuildContext context) async {
    final eventRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('events')
        .doc(widget.eventId);

    final updatedEventData = {
      'eventName': _eventName,
      'eventLocation': _eventLocation,
    };

    try {
      await eventRef.update(updatedEventData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detalhes do evento atualizados!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar detalhes do evento: $error')),
      );
    }
  }
}
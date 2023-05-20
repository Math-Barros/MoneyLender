import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventScreen extends StatefulWidget {
  static const String id = '/add_event';

  final User user;

  const AddEventScreen({required this.user});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();

  void _addEvent() {
    String eventName = _eventNameController.text.trim();
    String eventDescription = _eventDescriptionController.text.trim();

    if (eventName.isNotEmpty && eventDescription.isNotEmpty) {
      FirebaseFirestore.instance.collection('events').add({
        'name': eventName,
        'description': eventDescription,
        'creatorId': widget.user.uid,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso!')),
        );
        _eventNameController.clear();
        _eventDescriptionController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao adicionar o evento.')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Nome do Evento'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _eventDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Descrição do Evento'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addEvent,
              child: const Text('Adicionar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}

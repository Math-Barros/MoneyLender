import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditEventScreen extends StatefulWidget {
  final String eventId;
  final User user;

  const EditEventScreen({
    Key? key,
    required this.eventId,
    required this.user,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  String _eventName = '';
  String _eventDescription = '';

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Nome do Evento'),
              onChanged: (value) {
                setState(() {
                  _eventName = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _eventDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Descrição do Evento'),
              onChanged: (value) {
                setState(() {
                  _eventDescription = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _updateEventDetails(context),
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchEventData() async {
    final eventDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('events')
        .doc(widget.eventId)
        .get();

    if (eventDoc.exists) {
      setState(() {
        _eventName = eventDoc['name'];
        _eventDescription = eventDoc['description'];
      });
      _eventNameController.text = _eventName;
      _eventDescriptionController.text = _eventDescription;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento não encontrado.')),
      );
      Navigator.pop(context); // Volte para a tela anterior
    }
  }

  void _updateEventDetails(BuildContext context) async {
    final eventRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('events')
        .doc(widget.eventId);

    final updatedEventData = {
      'name': _eventNameController.text,
      'description': _eventDescriptionController.text,
    };

    try {
      await eventRef.update(updatedEventData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detalhes do evento atualizados!')),
      );
      Navigator.pop(context); // Volte para a tela anterior
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar detalhes do evento: $error')),
      );
    }
  }
}

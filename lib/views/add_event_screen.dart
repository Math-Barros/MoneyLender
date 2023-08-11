import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/edit_event_screen.dart';

class AddEventScreen extends StatefulWidget {
  final User user;

  const AddEventScreen({super.key, required this.user});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  bool _showEditOrDelete = false;
  String? _createdEventId;

  Future<void> _addEvent() async {
    String eventName = _eventNameController.text.trim();
    String eventDescription = _eventDescriptionController.text.trim();

    if (eventName.isNotEmpty && eventDescription.isNotEmpty) {
      try {
        DocumentReference eventDocRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('events')
            .add({
          'name': eventName,
          'description': eventDescription,
          'creatorId': widget.user.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso!')),
        );
        _eventNameController.clear();
        _eventDescriptionController.clear();
        _createdEventId = eventDocRef.id;

        // Agora você pode verificar se o usuário atual é o criador do evento
        if (_createdEventId != null) {
          _showEditOrDeleteButton();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao adicionar o evento.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  void _showEditOrDeleteButton() {
    setState(() {
      // Ativar a exibição do botão de editar/excluir
      _showEditOrDelete = true;
    });
  }

  void _editEvent() {
    if (_createdEventId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditEventScreen(
            eventId: _createdEventId!,
            user: widget.user,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum evento criado ainda.')),
      );
    }
  }

  void _deleteEvent() async {
    if (_createdEventId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('events')
            .doc(_createdEventId!)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento excluído com sucesso!')),
        );
        setState(() {
          _showEditOrDelete = false;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir o evento: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum evento criado ainda.')),
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
            if (_showEditOrDelete) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _editEvent,
                child: const Text('Editar Evento'),
              ),
              ElevatedButton(
                onPressed: _deleteEvent,
                child: const Text('Excluir Evento'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

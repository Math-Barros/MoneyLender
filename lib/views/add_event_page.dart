import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylender/views/widgets/events/action_buttons.dart';
import 'package:moneylender/views/widgets/events/event_form.dart';
import '../controllers/add_event_controller.dart';

class AddEventPage extends StatefulWidget {
  final User user;

  const AddEventPage({super.key, required this.user});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final AddEventController _controller = AddEventController();
  bool _showEditOrDelete = false;
  String? _createdEventId;

  void _handleAddEvent(String name, String description) async {
    try {
      String? eventId = await _controller.addEvent(
        name: name,
        description: description,
        userId: widget.user.uid,
      );
      if (eventId != null) {
        setState(() {
          _createdEventId = eventId;
          _showEditOrDelete = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso!')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $error')),
      );
    }
  }

  void _handleDeleteEvent() async {
    if (_createdEventId != null) {
      try {
        await _controller.deleteEvent(widget.user.uid, _createdEventId!);
        setState(() {
          _showEditOrDelete = false;
          _createdEventId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento excluído com sucesso!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBB26A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCBB26A),
        title: const Text('Adicionar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EventForm(
              onAddEvent: _handleAddEvent,
            ),
            if (_showEditOrDelete)
              ActionButtons(
                onDelete: _handleDeleteEvent,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moneylender/controllers/edit_event_controller.dart';
import 'package:moneylender/models/event_model.dart';
import 'package:moneylender/views/widgets/events/event_description_field.dart';
import 'package:moneylender/views/widgets/events/event_name_field.dart';
import 'package:moneylender/views/widgets/events/save_button.dart';

class EditEventPage extends StatefulWidget {
  final String eventId;
  final String userId;

  const EditEventPage({
    super.key,
    required this.eventId,
    required this.userId,
  });

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late final EditEventController _controller;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = EditEventController(
      userId: widget.userId,
      eventId: widget.eventId,
    );
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    final event = await _controller.fetchEvent();
    if (event != null) {
      setState(() {
        _nameController.text = event.name;
        _descriptionController.text = event.description;
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento não encontrado.')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _saveEvent() async {
    final updatedEvent = EventModel(
      id: widget.eventId,
      name: _nameController.text,
      description: _descriptionController.text,
      creatorId: widget.userId, // Corrigido: Passando o userId como creatorId
    );

    try {
      await _controller.updateEvent(updatedEvent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detalhes do evento atualizados!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EventNameField(controller: _nameController),
            const SizedBox(height: 16.0),
            EventDescriptionField(controller: _descriptionController),
            const SizedBox(height: 16.0),
            SaveButton(onPressed: _saveEvent),
          ],
        ),
      ),
    );
  }
}

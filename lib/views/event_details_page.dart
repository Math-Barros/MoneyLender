import 'package:flutter/material.dart';
import 'package:moneylender/views/widgets/events/event_details_body.dart';
import '../controllers/event_details_controller.dart';
class EventDetailsPage extends StatelessWidget {
  final String eventId;
  final String userId;

  EventDetailsPage({super.key, required this.eventId, required this.userId});

  final EventDetailsController _controller = EventDetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _controller.fetchEventData(userId, eventId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Carregando...');
            }
            if (snapshot.hasData) {
              return Text(snapshot.data?['name'] ?? 'Detalhes do Evento');
            }
            return const Text('Evento não encontrado');
          },
        ),
      ),
      body: EventDetailsBody(
        eventId: eventId,
        userId: userId,
        controller: _controller,
      ),
    );
  }
}

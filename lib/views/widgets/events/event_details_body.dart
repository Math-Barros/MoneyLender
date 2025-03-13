import 'package:flutter/material.dart';
import 'package:moneylender/controllers/event_details_controller.dart';
import 'rateio_form.dart';

class EventDetailsBody extends StatelessWidget {
  final String eventId;
  final String userId;
  final EventDetailsController controller;

  const EventDetailsBody({
    super.key,
    required this.eventId,
    required this.userId,
    required this.controller,
  });

  void _navigateToEditEvent(BuildContext context) {
    Navigator.pushNamed(context, '/edit-event', arguments: {'eventId': eventId, 'userId': userId});
  }

  void _deleteEvent(BuildContext context) async {
    await controller.deleteEvent(userId, eventId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento excluído com sucesso!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: controller.fetchEventData(userId, eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final eventData = snapshot.data!;
          final rateios = eventData['rateios'] as List<dynamic>? ?? [];
          final total = controller.calculateTotal(rateios);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Valor Total: $total', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _navigateToEditEvent(context),
                  child: const Text('Editar Evento'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _deleteEvent(context),
                  child: const Text('Excluir Evento'),
                ),
                const SizedBox(height: 16),
                RateioForm(
                  onCreate: (valor, amigos) async {
                    await controller.addRateio(userId, eventId, valor, amigos);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rateio criado com sucesso!')),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Evento não encontrado.'));
      },
    );
  }
}

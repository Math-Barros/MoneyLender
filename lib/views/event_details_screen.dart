import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylender/views/edit_event_screen.dart';
import 'package:moneylender/views/friend_list_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final User user;

  const EventDetailsScreen({
    Key? key,
    required this.eventId,
    required this.user,
  }) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  String _eventName = '';
  double _rateioValue = 0.0;
  final List<String> _selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_eventName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID do Evento: ${widget.eventId}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _openFriendListScreen(context),
              child: const Text('Adicionar Amigo'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _createExpense(context),
              child: const Text('Criar Rateio'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToEditEventScreen(),
              child: const Text('Editar Evento'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _deleteEventFromFirestore(),
              child: const Text('Excluir Evento'),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .collection('events')
                  .doc(widget.eventId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  final eventData = snapshot.data?.data();
                  final rateios = eventData?['rateios'] as List<dynamic>? ?? [];
                  final total = _calculateTotal(rateios);

                  return Text(
                    'Valor Total do Evento: $total',
                    style: const TextStyle(fontSize: 20),
                  );
                }

                if (snapshot.hasError) {
                  return const Text(
                      'Ocorreu um erro ao carregar os detalhes do evento.');
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal(List<dynamic> rateios) {
    double total = 0.0;

    for (final rateio in rateios) {
      final valor = rateio['valor'] as double?;
      if (valor != null) {
        total += valor;
      }
    }

    return total;
  }

  void _fetchEventData() async {
    final eventDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('events')
        .doc(widget.eventId)
        .get();

    if (eventDoc.exists) {
      final eventData = eventDoc.data();
      setState(() {
        _eventName = eventData?['name'] ?? '';
      });
    }
  }

  void _openFriendListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendListScreen(userId: widget.user.uid),
      ),
    );
  }

  void _createExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Rateio'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Valor do Rateio'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            setState(() {
              _rateioValue = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final eventRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .collection('events')
                  .doc(widget.eventId);

              final eventSnapshot = await eventRef.get();
              final eventData = eventSnapshot.data();
              if (eventData != null) {
                final rateios = eventData['rateios'] as List<dynamic>? ?? [];

                final novoRateio = {
                  'valor': _rateioValue,
                  'amigos': _selectedFriends,
                };

                rateios.add(novoRateio);

                await eventRef.update({
                  'rateios': rateios,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rateio criado com sucesso!')),
                );

                Navigator.of(context).pop();
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditEventScreen() async {
    final eventDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('events')
        .doc(widget.eventId)
        .get();

    if (eventDoc.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditEventScreen(
            eventId: widget.eventId,
            user: widget.user,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento não encontrado')),
      );
    }
  }

  void _deleteEventFromFirestore() async {
    final eventRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('events')
        .doc(widget.eventId);

    await eventRef.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento excluído com sucesso!')),
    );

    Navigator.of(context).pop();
  }
}

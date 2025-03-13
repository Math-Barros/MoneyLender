import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchEventData(String userId, String eventId) async {
    final eventDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .get();

    return eventDoc.data();
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .delete();
  }

  Future<void> addRateio(String userId, String eventId, double valor, List<String> amigos) async {
    final eventRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId);

    final eventSnapshot = await eventRef.get();
    final eventData = eventSnapshot.data();

    if (eventData != null) {
      final rateios = eventData['rateios'] as List<dynamic>? ?? [];
      rateios.add({'valor': valor, 'amigos': amigos});

      await eventRef.update({'rateios': rateios});
    }
  }

  double calculateTotal(List<dynamic> rateios) {
    return rateios.fold(0.0, (total, rateio) {
      final valor = rateio['valor'] as double?;
      return total + (valor ?? 0.0);
    });
  }
}

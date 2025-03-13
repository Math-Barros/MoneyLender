import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/models/event_model.dart';

class EditEventController {
  final String userId;
  final String eventId;

  EditEventController({
    required this.userId,
    required this.eventId,
  });

  Future<EventModel?> fetchEvent() async {
    final eventDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .get();

    if (eventDoc.exists) {
      return EventModel.fromMap(eventDoc.data()! as String, eventDoc.id as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateEvent(EventModel event) async {
    final eventRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId);

    await eventRef.update(event.toMap());
  }
}

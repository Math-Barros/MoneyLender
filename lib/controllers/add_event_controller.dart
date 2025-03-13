import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addEvent(
      {required String name,
      required String description,
      required String userId}) async {
    if (name.isEmpty || description.isEmpty) {
      return null;
    }

    try {
      DocumentReference eventDocRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .add({
        'name': name,
        'description': description,
        'creatorId': userId,
      });

      return eventDocRef.id;
    } catch (error) {
      throw Exception('Erro ao adicionar o evento: $error');
    }
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (error) {
      throw Exception('Erro ao excluir o evento: $error');
    }
  }
}

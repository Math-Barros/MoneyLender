class EventModel {
  final String id;
  final String name;
  final String description;
  final String creatorId;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'creatorId': creatorId,
    };
  }

  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      name: map['name'],
      description: map['description'],
      creatorId: map['creatorId'],
    );
  }
}
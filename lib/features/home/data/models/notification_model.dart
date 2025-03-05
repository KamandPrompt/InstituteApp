import 'package:mongo_dart/mongo_dart.dart';

class Notification {
  final String id;
  final String title;
  final String by;
  final String description;
  final String? image;

  Notification({
    required this.id,
    required this.title,
    required this.by,
    required this.description,
    this.image,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: (json['_id'] as ObjectId).oid,
      title: json['title'],
      by: json['by'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'description': description,
      'image': image,
    };
  }
}

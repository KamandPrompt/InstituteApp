import 'package:mongo_dart/mongo_dart.dart';

class PostItem {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String link;
  final String host;
  final String type;
  final String emailId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.link,
      required this.host,
      required this.type,
      required this.emailId,
      required this.createdAt,
      required this.updatedAt,
      });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(
        id: (json['_id'] as ObjectId).oid,
        title: json['title'],
        description: json['description'],
        images: List<String>.from(json['images']),
        link: json['link'],
        host: json['host'],
        type: json['type'],
        emailId: json['emailId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'link': link,
      'host': host,
      'type': type,
      'emailId': emailId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

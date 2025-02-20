import 'package:mongo_dart/mongo_dart.dart';

class Feeditem {
  final String id;
  final String host;
  final String description;
  final List<String> images;
  final String link;

  Feeditem(
      {required this.id,
      required this.host,
      required this.description,
      required this.images,
      required this.link});

  factory Feeditem.fromJson(Map<String, dynamic> json) {
    return Feeditem(
        id: (json['_id'] as ObjectId).oid,
        host: json['host'],
        description: json['description'],
        images: List<String>.from(json['images']),
        link: json['link']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'host': host,
      'description': description,
      'images': images,
      'link': link
    };
  }
}

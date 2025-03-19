import 'package:mongo_dart/mongo_dart.dart';

class FeedItem {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String link;
  final String host;

  FeedItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.link,
      required this.host});

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
        id: (json['_id'] as ObjectId).oid,
        title: json['title'],
        description: json['description'],
        images: List<String>.from(json['images']),
        link: json['link'],
        host: json['host'],);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'link': link,
      'host': host,
    };
  }
}

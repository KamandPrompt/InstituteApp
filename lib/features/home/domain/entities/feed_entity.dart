class FeedItemEntity {
  final String id;
  final String host;
  final String description;
  final List<String> images;
  final String link;
  final String organiser;

  FeedItemEntity(
      {required this.id,
      required this.host,
      required this.description,
      required this.images,
      required this.link,
      required this.organiser
      });

  factory FeedItemEntity.fromJson(Map<String, dynamic> json) {
    return FeedItemEntity(
      id: json['id'],
      host: json['host'],
      description: json['description'],
      images: List<String>.from(json['images']),
      link: json['link'],
      organiser:json['organiser']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'host': host,
      'description': description,
      'images': images,
      'link': link,
      'organiser':organiser
    };
  }
}
class FeedItemEntity {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String link;
  final String host;

  FeedItemEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.link,
      required this.host,
      });

  factory FeedItemEntity.fromJson(Map<String, dynamic> json) {
    return FeedItemEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: List<String>.from(json['images']),
      link: json['link'],
      host: json['host'],
    );
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
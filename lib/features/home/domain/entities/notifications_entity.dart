class NotificationEntity {
  final String id;
  final String title;
  final String by;
  final String description;
  final String? image;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.by,
    required this.description,
    this.image,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'],
      title: json['title'],
      by: json['by'],
      description: json['description'],
      image: json['image'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'description': description,
      'image': image ?? "",
    };
  }
}

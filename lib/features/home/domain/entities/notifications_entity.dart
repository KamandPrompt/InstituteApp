class NotificationEntity {
  final String id;
  final Map<String, dynamic> title;
  final Map<String, dynamic> by;
  final Map<String, dynamic> description;
  final Map<String, dynamic>? image; // ✅ Make image nullable

  NotificationEntity({
    required this.id,
    required this.title,
    required this.by,
    required this.description,
    this.image, // ✅ Nullable image field
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['_id']?.toString() ?? '',
      title: json['title'] is Map<String, dynamic>
          ? json['title']
          : {'text': json['title'] ?? 'No Title'},
      by: json['by'] is Map<String, dynamic>
          ? json['by']
          : {'name': json['by'] ?? 'Unknown'},
      description: json['description'] is Map<String, dynamic>
          ? json['description']
          : {'content': json['description'] ?? 'No Description'},
      image: json['image'] is Map<String, dynamic>
          ? json['image']
          : null, // ✅ Ensure image is now treated as a Map
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'description': description,
      if (image != null) 'image': image, // ✅ Include image only if not null
    };
  }
}

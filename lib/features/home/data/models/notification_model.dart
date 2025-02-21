class Notification {
  final String title;
  final String by;
  final String description;
  final String? image;

  Notification({
    required this.title,
    required this.by,
    required this.description,
    this.image,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'], // Ensure field names match your MongoDB schema
      by: json['by'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'by': by,
      'description': description,
      'image': image,
    };
  }
}

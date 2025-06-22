class LostFoundItemEntity {
  final String id;
  final String from;
  final String lostOrFound;
  final String name;
  final String description;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNo;

  LostFoundItemEntity({
    required this.id,
    required this.from,
    required this.lostOrFound,
    required this.name,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNo,
  });

  factory LostFoundItemEntity.fromJson(Map<String, dynamic> json) {
    return LostFoundItemEntity(
      id: json['id'],
      from: json['from'],
      lostOrFound: json['lostOrFound'],
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNo: json['phoneNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'lostOrFound': lostOrFound,
      'name': name,
      'description': description,
      'images': images,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phoneNo': phoneNo,
    };
  }
}

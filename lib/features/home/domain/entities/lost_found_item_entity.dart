class LostFoundItemEntity {
  final String id;
  final String from;
  final String lostOrFound;
  final String name;
  final String description;
  final List<String> images;
  final DateTime date;
  final String phoneNo;

  LostFoundItemEntity({
    required this.id,
    required this.from,
    required this.lostOrFound,
    required this.name,
    required this.description,
    required this.images,
    required this.date,
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
      date: json['date'],
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
      'date': date,
      'phoneNo': phoneNo,
    };
  }
}

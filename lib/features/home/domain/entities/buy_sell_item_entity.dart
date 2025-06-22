class BuySellItemEntity {
  final String id;
  final String name;
  final String productDescription;
  final List<String> productImage;
  final String soldBy;
  final String maxPrice;
  final String minPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNo;

  BuySellItemEntity({
    required this.id,
    required this.name,
    required this.productDescription,
    required this.productImage,
    required this.soldBy,
    required this.maxPrice,
    required this.minPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNo,
  });

  factory BuySellItemEntity.fromJson(Map<String, dynamic> json) {
    return BuySellItemEntity(
      id: json['id'],
      name: json['name'],
      productDescription: json['productDescription'],
      productImage: List<String>.from(json['productImage']),
      soldBy: json['soldBy'],
      maxPrice: json['maxPrice'],
      minPrice: json['minPrice'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      phoneNo: json['phoneNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'productDescription': productDescription,
      'productImage': productImage,
      'soldBy': soldBy,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'phoneNo': phoneNo,
    };
  }
}

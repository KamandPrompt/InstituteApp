class BuySellItemEntity {
  final String id;
  final String productName;
  final String productDescription;
  final List<String> productImage;
  final String soldBy;
  final int maxPrice;
  final int minPrice;
  final DateTime addDate;
  final String phoneNo;

  BuySellItemEntity({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.soldBy,
    required this.maxPrice,
    required this.minPrice,
    required this.addDate,
    required this.phoneNo,
  });

  factory BuySellItemEntity.fromJson(Map<String, dynamic> json) {
    return BuySellItemEntity(
      id: json['id'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productImage: List<String>.from(json['productImage']),
      soldBy: json['soldBy'],
      maxPrice: json['maxPrice'],
      minPrice: json['minPrice'],
      addDate: DateTime.parse(json['addDate']),
      phoneNo: json['phoneNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productDescription': productDescription,
      'productImage': productImage,
      'soldBy': soldBy,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'addDate': addDate.toIso8601String(),
      'phoneNo': phoneNo,
    };
  }
}


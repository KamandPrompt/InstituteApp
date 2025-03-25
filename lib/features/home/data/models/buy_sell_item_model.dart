import 'package:mongo_dart/mongo_dart.dart';

class BuySellItem {
  final String id;
  final String productName;
  final String productDescription;
  final List<String> productImage;
  final String soldBy;
  final String maxPrice;
  final String minPrice;  // User who added the item for selling
  final DateTime addDate;
  final String phoneNo; // WhatsApp number

  BuySellItem({
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

  factory BuySellItem.fromJson(Map<String, dynamic> json) {
    return BuySellItem(
      id: (json['_id'] as ObjectId).oid,
      productName: json['productName'],
      productDescription: json['productDescription'],
      productImage: List<String>.from(json['productImage']),
      soldBy: json['soldBy'],
      maxPrice: json['maxPrice'],
      minPrice: json['minPrice'],
      addDate: json['addDate'],
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
      'addDate': addDate,
      'phoneNo': phoneNo,
    };
  }
}


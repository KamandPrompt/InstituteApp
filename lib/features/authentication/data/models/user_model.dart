import 'package:mongo_dart/mongo_dart.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? image;

  User(
      {required this.id,
      required this.image,
      required this.name,
      required this.email,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        id: (json['_id'] as ObjectId).oid,
        image: json['image']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
      'password': password
    };
  }
}

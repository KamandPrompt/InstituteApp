import 'package:mongo_dart/mongo_dart.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? image;

  User({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      id: (json['_id'] as ObjectId).oid,
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
      'password': password,
    };
  }
}

// ✅ New Admin Class Extending User
class Admin extends User {
  static final List<String> adminEmails = [
    "technical_secretary@students.iitmandi.ac.in",
    "research_secretary@students.iitmandi.ac.in",
    "pgacademic_secretary@students.iitmandi.ac.in",
    "ugacademic_secretary@students.iitmandi.ac.in",
    "robotronics@students.iitmandi.ac.in",
    "yantrik_club@students.iitmandi.ac.in",
    "pc@students.iitmandi.ac.in",
    "sae@iitmandi.ac.in",
    "stac@students.iitmandi.ac.in",
    "edc@students.iitmandi.ac.in",
    "nirmaan_club@students.iitmandi.ac.in",
    "cultural_secretary@students.iitmandi.ac.in",
    "academic_secretary@students.iitmandi.ac.in",
    "media@students.iitmandi.ac.in",
    "literary_secretary@students.iitmandi.ac.in",
    "danceclub@students.iitmandi.ac.in",
    "designauts@students.iitmandi.ac.in",
    "dramaclub@students.iitmandi.ac.in",
    "ebsb@students.iitmandi.ac.in",
    "spicmacay@students.iitmandi.ac.in",
    "pmc@students.iitmandi.ac.in",
    "musicclub@students.iitmandi.ac.in",
    "artgeeks@students.iitmandi.ac.in",
    "writing_club@students.iitmandi.ac.in",
    "debating_club@students.iitmandi.ac.in",
    "quizzing_club@students.iitmandi.ac.in",
    "b24258@students.iitmandi.ac.in"
  ];

  Admin({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.image,
  });

  // ✅ Factory method to create an Admin instance only if email is in the list
  factory Admin.fromJson(Map<String, dynamic> json) {
    if (!adminEmails.contains(json['email'])) {
      throw Exception("Unauthorized Admin email: ${json['email']}");
    }
    return Admin(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      id: (json['_id'] as ObjectId).oid,
      image: json['image'],
    );
  }

  // ✅ Check if a user is an admin
  static bool isAdmin(String email) {
    return adminEmails.contains(email);
  }
}

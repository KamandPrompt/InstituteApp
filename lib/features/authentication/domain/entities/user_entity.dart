class UserEntity {
  // final String id;
  final String name;
  final String email;
  final String password;
  final String? image;

  UserEntity(
      {
        // required this.id,
      required this.image,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'image': image,
      'email': email,
      'password': password
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        // id: json['id'],
        image: json['image']);
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profileImage; // si lo usas más adelante
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        role: json["role"] ?? "",
        profileImage: json["profile_image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "profile_image": profileImage,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

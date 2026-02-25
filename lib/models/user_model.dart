class User {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final String? role;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['profile_image'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image': profileImage,
      'role': role,
    };
  }
}

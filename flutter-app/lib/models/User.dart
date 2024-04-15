class User {
  final int id;
  final String name;
  final String? bio;
  final String email;
  final String? password;

  const User({
    required this.id,
    required this.name,
    this.bio,
    required this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      email: json['email'],
      password: json['password'],
    );
  }
}

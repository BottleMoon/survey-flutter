class User {
  final String email;
  final String accessToken;
  final String refreshToken;

  User(
      {required this.email,
      required this.accessToken,
      required this.refreshToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }
}

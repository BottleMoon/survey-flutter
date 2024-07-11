class User {
  bool isSignIn = false;

  User({this.isSignIn = true});

  factory User.fromJson(Map<String, dynamic> json) {
    return User();
  }
}

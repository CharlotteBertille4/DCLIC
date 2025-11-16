class User {
  //declaration des propriétes
  String id;
  String username;
  String email;
  String password;

  //constructeur de la classe User
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  //Conversion d'un objet user en map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  //creer un User à partir d'un map
  factory User.fromMap(Map<String, dynamic> map) {
    // On convertit toujours en String pour éviter les erreurs de type
    final id = map['id'] != null ? map['id'].toString() : '';
    final username = map['username'] != null ? map['username'].toString() : '';
    final email = map['email'] != null ? map['email'].toString() : '';
    final password = map['password'] != null ? map['password'].toString() : '';

    return User(id: id, username: username, email: email, password: password);
  }
}

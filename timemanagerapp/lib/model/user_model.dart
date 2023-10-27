class UserModel {
  int id;
  String firstname;
  String lastname;
  String email;
  String password;
  int role;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.role,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        firstname = json['firstname'] ?? '',
        lastname = json['lastname'] ?? '',
        email = json['email'] ?? '',
        password = json['password'] ?? '',
        role = json['role'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    return data;
  }
}

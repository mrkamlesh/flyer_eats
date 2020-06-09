class User {
  final String name;
  final String username;
  final String phone;
  final bool hasAddress;
  final String token;
  final String avatar;
  final String password;

  User(
      {this.password,
      this.avatar,
      this.name,
      this.username,
      this.phone,
      this.hasAddress,
      this.token});

  factory User.fromJson(
      Map<String, dynamic> parsedJson, String username, String password) {
    return User(
      name: parsedJson['client_name_cookie'],
      phone: parsedJson['contact_phone'],
      username: username,
      password: password,
      avatar: parsedJson['avatar'],
      hasAddress: parsedJson['has_addressbook'] == '2' ? true : false,
      token: parsedJson['token'],
    );
  }
}

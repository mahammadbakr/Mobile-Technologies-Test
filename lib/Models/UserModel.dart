import 'dart:convert';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  int id;
  int IMEI;
  String firstName;
  String lastName;
  String doB;
  int passport;
  String email;
  String picture;

  User({
    this.id,
    this.IMEI,
    this.firstName,
    this.lastName,
    this.doB,
    this.passport,
    this.email,
    this.picture,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json["id"],
        IMEI: json["IMEI"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        doB: json["doB"],
        passport: json["passport"],
        email: json["email"],
        picture: json["picture"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "IMEI": IMEI,
        "first_name": firstName,
        "last_name": lastName,
        "doB": doB,
        "passport": passport,
        "email": email,
        "picture": picture,
      };
}

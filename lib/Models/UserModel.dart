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
  String deviceName;
  double lat;
  double lng;

  User(
      {this.id,
      this.IMEI,
      this.firstName,
      this.lastName,
      this.doB,
      this.passport,
      this.email,
      this.picture,
      this.deviceName,
      this.lat,
      this.lng});

  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json["id"],
      IMEI: json["IMEI"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      doB: json["doB"],
      passport: json["passport"],
      email: json["email"],
      picture: json["picture"],
      deviceName: json["deviceName"],
      lat: json["lat"],
      lng: json["lng"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "IMEI": IMEI,
        "first_name": firstName,
        "last_name": lastName,
        "doB": doB,
        "passport": passport,
        "email": email,
        "picture": picture,
        "deviceName": deviceName,
        "lat": lat,
        "lng": lng
      };
}

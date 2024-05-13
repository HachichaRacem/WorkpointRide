class User {
  static final User _user = User._internal();
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? role;
  bool? isBlocked;
  List? favoritePlaces;
  factory User() {
    return _user;
  }
  User._internal();
  void updateFromJSON(Map json) {
    print("[USER]: update from JSON has been called with $json");
    id = json['_id'];
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    phoneNumber = json["phoneNumber"] ?? "Not provided yet";
    role = json["role"];
    isBlocked = json["isBlocked"];
    favoritePlaces = json["favoritePlaces"];
  }
}

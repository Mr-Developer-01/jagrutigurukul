class UserModal {
  String? uid;
  String? fullName;
  String? email;
  String? profilepic;

  UserModal({this.uid, this.fullName, this.email, this.profilepic});

  UserModal.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "profilepic": profilepic,
    };
  }
}
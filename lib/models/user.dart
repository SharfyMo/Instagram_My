import 'package:cloud_firestore/cloud_firestore.dart';

class UserDate {
  String password;
  String email;
  String title;
  String username;
  String age;
  String profileimg;
  String uid;
  List following;
  List followers;

  UserDate(
      {required this.email,
      required this.password,
      required this.title,
      required this.username,
      required this.age,
      required this.profileimg,
      required this.uid,
      required this.following,
      required this.followers});

// To convert the UserData(Data type) to   Map<String, Object>
  Map<String, dynamic> convert2Map() {
    return {
      "password": password,
      "email": email,
      "title": title,
      "username": username,
      "age": age,
      "profileimg": profileimg,
      "uid": uid,
      "following": following,
      "followers": followers
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserDate(
      password: snapshot["password"],
      email: snapshot["email"],
      title: snapshot["title"],
      username: snapshot["username"],
      age: snapshot["age"],
      profileimg: snapshot["profileimg"],
      uid: snapshot["uid"],
      following: snapshot["following"],
      followers: snapshot["followers"],
    );
  }
}

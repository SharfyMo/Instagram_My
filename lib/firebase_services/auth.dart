import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_my/firebase_services/storage.dart';
import 'package:instagram_my/models/user.dart';
import 'package:instagram_my/shared/snackbar.dart';

class AuthMethods {
  register(
      {required emailll,
      required passworddd,
      required context,
      required titleee,
      required usernameee,
      required agee,
      required imgName,
      required imgPath}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailll,
        password: passworddd,
      );

// firebase firestore (Database)
      CollectionReference users =
          FirebaseFirestore.instance.collection('InstaMY');

      String urlll = await getImgURL(
          imgName: imgName, imgPath: imgPath, folderName: 'profileimg');

      UserDate userr = UserDate(
          email: emailll,
          password: passworddd,
          title: titleee,
          username: usernameee,
          age: agee,
          profileimg: urlll,
          uid: credential.user!.uid,
          followers: [],
          following: []);

      users
          .doc(credential.user!.uid)
          .set(userr.convert2Map())
          .then((value) => showSnackBarMessage(context, "User Added", true))
          .catchError((error) => showSnackBarMessage(
              context, "Failed to add user: $error", false));
    } on FirebaseAuthException catch (e) {
      showSnackBarMessage(context, "ERROR :  ${e.code} ", false);
    } catch (e) {
      showSnackBarMessage(context, e.toString(), false);
    }
  }

  signIn({required emailll, required passworddd, required context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailll, password: passworddd);
      showSnackBarMessage(context, "Logged in successfully", true);
    } on FirebaseAuthException catch (e) {
      showSnackBarMessage(context, e.code, false);
      //  showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBarMessage(context, e.toString(), false);
    }
  }

  // functoin to get user details from Firestore (Database)
  Future<UserDate> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('InstaMY')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserDate.convertSnap2Model(snap);
  }
}

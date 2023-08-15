import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_my/firebase_services/storage.dart';
import 'package:instagram_my/models/post.dart';
import 'package:instagram_my/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadPost(
      {required imgName,
      required imgPath,
      required description,
      required profileImg,
      required username,
      required context}) async {
    try {
// ______________________________________________________________________

      String urlll = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'imgpost/${FirebaseAuth.instance.currentUser!.uid}');

// _______________________________________________________________________
// firebase firestore (Database)
      CollectionReference posts =
          FirebaseFirestore.instance.collection('postt');

      String newId = const Uuid().v1();

      PostData postt = PostData(
          datePublished: DateTime.now(),
          description: description,
          imgPost: urlll,
          likes: [],
          profileImg: profileImg,
          //  postId: Random().nextInt(200000).toString(),
          postId: newId,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username);

      posts
          .doc(
            newId,
          )
          .set(postt.convert2Map())
          .then((value) => showSnackBarMessage(context, "Add Post", true))
          .catchError((error) =>
              showSnackBarMessage(context, "Failed to post: $error", false));
    } on FirebaseAuthException catch (e) {
      showSnackBarMessage(context, "ERROR :  ${e.code} ", false);
    } catch (e) {
      showSnackBarMessage(context, e.toString(), false);
    }
  }

  //---------------- Add Likes
  changlike({required Map postData, required context}) async {
    try {
      if (postData["likes"].contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance
            .collection("postt")
            .doc(postData["postId"])
            .update({
          "likes":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("postt")
            .doc(postData["postId"])
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (e) {
      showSnackBarMessage(context, e.toString(), false);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_my/shared/colors.dart';
import 'package:instagram_my/shared/contants.dart';
import 'package:instagram_my/shared/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  final Map data;
  final bool showText;
  const CommentsScreen({Key? key, required this.data, required this.showText})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('postt')
                .doc(widget.data['postId'])
                .collection('commentS')
                .orderBy("dataPublished")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }

              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(125, 78, 91, 110),
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profilePic']),
                                  radius: 22,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(data['username'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      Text(data['textComment'],
                                          style: const TextStyle(fontSize: 13))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      DateFormat('MMMM d, ' 'y').format(
                                          data["dataPublished"].toDate()),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite))
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          widget.showText
              ? Container(
                  margin: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(125, 78, 91, 110),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData!.profileimg),
                          radius: 26,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            decoration: decorationTextfield.copyWith(
                                hintText: "Comment as ${userData.username}  ",
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (commentController.text.isNotEmpty) {
                                        String commentId = const Uuid().v1();
                                        await FirebaseFirestore.instance
                                            .collection("postt")
                                            .doc(widget.data["postId"])
                                            .collection("commentS")
                                            .doc(commentId)
                                            .set({
                                          "profilePic": userData.profileimg,
                                          "username": userData.username,
                                          "textComment": commentController.text,
                                          "dataPublished": DateTime.now(),
                                          "uid": userData.uid,
                                          "commentId": commentId
                                        });

                                        commentController.clear();
                                        //   showSnackBar(context, "ADD Comment");
                                      } else {
                                        showSnackBarMessage(context,
                                            "Please Write Comment", false);
                                      }
                                    },
                                    icon: const Icon(Icons.send)))),
                      ),
                    ],
                  ),
                )
              : const Text("")
        ],
      ),
    );
  }
}

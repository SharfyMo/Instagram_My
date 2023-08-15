import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_my/firebase_services/firestore.dart';
import 'package:instagram_my/screens/comments.dart';
import 'package:instagram_my/shared/colors.dart';
import 'package:instagram_my/shared/heart_animation.dart';
import 'package:instagram_my/shared/snackbar.dart';
import 'package:intl/intl.dart';

class Postdesignn extends StatefulWidget {
  final Map data;

  const Postdesignn({super.key, required this.data});

  @override
  State<Postdesignn> createState() => _PostdesignnState();
}

class _PostdesignnState extends State<Postdesignn> {
  int commentcount = 0;
  bool showheart = false;
  // Global variable
  bool isLikeAnimating = false;

  getcommentcount() async {
    try {
      QuerySnapshot commentData = await FirebaseFirestore.instance
          .collection("postt")
          .doc(widget.data['postId'])
          .collection('commentS')
          .get();
      setState(() {
        commentcount = commentData.docs.length;
      });
    } catch (e) {
      showSnackBarMessage(context, e.toString(), false);
    }
  }

  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            FirebaseAuth.instance.currentUser!.uid == widget.data['uid']
                ? SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await FirebaseFirestore.instance
                          .collection("postt")
                          .doc(widget.data['postId'])
                          .delete();
                      setState(() {
                        showSnackBarMessage(context, "Delete this Post", true);
                      });
                    },
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Delete Post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Can Not Delete this Post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getcommentcount();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widthScreen > 600 ? mobileBackgroundColor : webBackgroundColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(125, 78, 91, 110)),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(widget.data['profileImg']),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(widget.data['username']),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      showmodel();
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                //  showheart = true;
                isLikeAnimating = true;
              });

              // Timer(Duration(seconds: 2), () {
              //   setState(() {
              //     showheart = false;
              //   });
              // });

              await FirebaseFirestore.instance
                  .collection("postt")
                  .doc(widget.data["postId"])
                  .update({
                "likes": FieldValue.arrayUnion(
                    [FirebaseAuth.instance.currentUser!.uid])
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.data['imgPost'],
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: const Center(
                                child: CircularProgressIndicator()));
                  },
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                ),
                // showheart
                //     ? Icon(
                //         Icons.favorite,
                //         color: Colors.white,
                //         size: 120,
                //       )
                //     : Text(""),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 111,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        await FirestoreMethods()
                            .changlike(postData: widget.data, context: context);
                      },
                      icon: widget.data["likes"]
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                data: widget.data,
                                showText: true,
                              ),
                            ));
                      },
                      icon: const Icon(Icons.comment_outlined)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                ],
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
            ],
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              child: Text(
                "${widget.data['likes'].length} ${widget.data['likes'].length > 1 ? "Likes" : "Like"}",
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
              )),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Text(
                  widget.data['username'],
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 189, 196, 199)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.data['description'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 189, 196, 199),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      data: widget.data,
                      showText: false,
                    ),
                  ));
            },
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5),
                child: Text(
                  "view all $commentcount like",
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                )),
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              child: Text(
                DateFormat('MMMM d, ' 'y')
                    .format(widget.data["datePublished"].toDate()),
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
              )),
        ],
      ),
    );
  }
}

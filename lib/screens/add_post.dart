import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_my/firebase_services/firestore.dart';
import 'package:instagram_my/provider/user_provider.dart';
import 'package:instagram_my/shared/colors.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

class Addpost extends StatefulWidget {
  const Addpost({super.key});

  @override
  State<Addpost> createState() => _AddpostState();
}

class _AddpostState extends State<Addpost> {
  Uint8List? imgPath;
  String? imgName;
  bool isloading = false;
  final desController = TextEditingController();

  uploadImage2Screen(ImageSource source) async {
    Navigator.pop(context);
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          // imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {}
    } catch (e) {
      //  showSnackBar(context,"Error => $e");
    }
  }

  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () async {
                // Navigator.of(context).pop();
                await uploadImage2Screen(ImageSource.camera);
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "From Camera",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                // Navigator.of(context).pop();
                await uploadImage2Screen(ImageSource.gallery);
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "From Gallary",
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
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    return imgPath == null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: IconButton(
                onPressed: () {
                  showmodel();
                },
                icon: const Icon(
                  Icons.upload,
                  size: 50,
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isloading = true;
                      });

                      await FirestoreMethods().uploadPost(
                          imgName: imgName,
                          imgPath: imgPath,
                          description: desController.text,
                          profileImg: allDataFromDB!.profileimg,
                          username: allDataFromDB.username,
                          context: context);
                      setState(() {
                        isloading = false;
                        imgPath = null;
                      });
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    )),
              ],
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                isloading
                    ? const LinearProgressIndicator()
                    : const Divider(
                        thickness: 1,
                        // height: 30,
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 33,
                      backgroundImage: NetworkImage(allDataFromDB!.profileimg
                          // "https://static-ai.asianetnews.com/images/01e42s5h7kpdte5t1q9d0ygvf7/1-jpeg.jpg"
                          ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: desController,
                        // controller: descriptionController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                            hintText: "write a caption...",
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: 66,
                      height: 74,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(imgPath!), fit: BoxFit.cover)),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_my/screens/profile.dart';
import 'package:instagram_my/shared/colors.dart';

class Searchh extends StatefulWidget {
  const Searchh({Key? key}) : super(key: key);

  @override
  State<Searchh> createState() => _SearchhState();
}

class _SearchhState extends State<Searchh> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(showUser);
  }

  showUser() {
    setState(() {});
  }

  @override
  void dispose() {
    myController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            // onChanged: (value) {
            //   setState(() {});
            // },
            controller: myController,
            decoration: const InputDecoration(
              labelText: 'Search for a user...',
              icon: Icon(
                Icons.search,
                color: primaryColor,
                size: 20.0,
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('InstaMY')
              .where("username", isEqualTo: myController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                  uiddd: snapshot.data!.docs[index]["uid"],
                                ),
                              ));
                        },
                        title: Text(snapshot.data!.docs[index]["username"]),
                        leading: CircleAvatar(
                          radius: 33,
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]["profileimg"]),
                        ),
                      ),
                    );
                  });
            }

            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          },
        ));
  }
}

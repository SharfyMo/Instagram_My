import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_my/screens/add_post.dart';
import 'package:instagram_my/screens/home.dart';
import 'package:instagram_my/screens/profile.dart';
import 'package:instagram_my/screens/search.dart';
import 'package:instagram_my/shared/colors.dart';

class Mymobilescerren extends StatefulWidget {
  const Mymobilescerren({super.key});

  @override
  State<Mymobilescerren> createState() => _MymobilescerrenState();
}

class _MymobilescerrenState extends State<Mymobilescerren> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentpage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            currentpage = index;
          });
        },
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: currentpage == 0 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: currentpage == 1 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: currentpage == 2 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: currentpage == 3 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: currentpage == 4 ? primaryColor : secondaryColor,
              ),
              label: ""),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const Home(),
          const Searchh(),
          const Addpost(),
          const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 225, 225, 225),
              radius: 71,
              backgroundImage: AssetImage("assets/img/mohamed.png"),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Mohamed Mahmoud Abo Hamd",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Developer Flutter",
              style: TextStyle(fontSize: 15),
            ),
          ]),
          Profile(
            uiddd: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_my/screens/add_post.dart';
import 'package:instagram_my/screens/home.dart';
import 'package:instagram_my/screens/profile.dart';
import 'package:instagram_my/screens/search.dart';
import 'package:instagram_my/shared/colors.dart';

class Mywebscerren extends StatefulWidget {
  const Mywebscerren({super.key});

  @override
  State<Mywebscerren> createState() => _MywebscerrenState();
}

class _MywebscerrenState extends State<Mywebscerren> {
  final PageController _pageController = PageController();
  int page = 0;

  navigate2Screen(int indexx) {
    _pageController.jumpToPage(indexx);
    setState(() {
      page = indexx;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: page == 0 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigate2Screen(0);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: page == 1 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigate2Screen(1);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: page == 2 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigate2Screen(2);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: page == 3 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigate2Screen(3);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: page == 4 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigate2Screen(4);
            },
          ),
        ],
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/img/instagram.svg",
          color: primaryColor,
          height: 32,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: 9, horizontal: MediaQuery.of(context).size.width / 4),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            const Home(),
            const Searchh(),
            const Addpost(),
            Container(
              color: mobileBackgroundColor,
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Developer Flutter",
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
            ),
            Profile(
              uiddd: FirebaseAuth.instance.currentUser!.uid,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dashed_circle/dashed_circle.dart';

class PersonInDataa extends StatefulWidget {
  const PersonInDataa({super.key});

  @override
  State<PersonInDataa> createState() => _PersonInDataaState();
}

class _PersonInDataaState extends State<PersonInDataa>
    with TickerProviderStateMixin {
  late Animation<double> base;
  late Animation gap;
  late Animation<double> reverse;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 0.0, end: 3.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('InstaMY').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        controller.forward().whenComplete(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: base,
                          child: DashedCircle(
                            gapSize: gap.value,
                            dashes: 40,
                            color: const Color(0XFFED4634),
                            child: RotationTransition(
                              turns: reverse,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    data['profileimg'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(data['username']),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

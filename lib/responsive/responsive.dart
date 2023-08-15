import 'package:flutter/material.dart';
import 'package:instagram_my/provider/user_provider.dart';
import 'package:instagram_my/responsive/mobile.dart';
import 'package:instagram_my/responsive/web.dart';
import 'package:provider/provider.dart';

class Responsive extends StatefulWidget {
  final Mymobilescerren mymobile;
  final Mywebscerren myweb;

  const Responsive({super.key, required this.mymobile, required this.myweb});

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  // To get data from DB using provider
  getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, boxConstraints) {
      if (boxConstraints.maxWidth > 600) {
        return widget.myweb;
      } else {
        return widget.mymobile;
      }
    });
  }
}

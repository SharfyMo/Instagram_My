import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_my/provider/user_provider.dart';
import 'package:instagram_my/responsive/mobile.dart';
import 'package:instagram_my/responsive/responsive.dart';
import 'package:instagram_my/responsive/web.dart';
import 'package:instagram_my/screens/sign_in.dart';
import 'package:instagram_my/shared/snackbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC6tgf6Gc7pf3MWTAeroaJ2g-0z4JzGm_M",
            authDomain: "myinstaa-81795.firebaseapp.com",
            projectId: "myinstaa-81795",
            storageBucket: "myinstaa-81795.appspot.com",
            messagingSenderId: "582017910310",
            appId: "1:582017910310:web:73a6a9bfee14accf8448e7"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return UserProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnackBarMessage(
                  context, "Something went wrong", false);
            } else if (snapshot.hasData) {
              return const Responsive(
                mymobile: Mymobilescerren(),
                myweb: Mywebscerren(),
              );
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}

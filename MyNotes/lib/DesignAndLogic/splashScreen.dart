import 'package:calculator/DesignAndLogic/singUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'NotesPage.dart';

class Splash extends StatefulWidget {
  final _storage = FlutterSecureStorage();
  signOut() async {
    FirebaseAuth.instance.signOut();
    await _storage.delete(key: 'user');
  }

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Widget currentPage = SignUp();
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    checkLogin();
    gotonextpage();
  }

  final _storage = FlutterSecureStorage();

  checkLogin() async {
    if (user != null) {
      await _storage.write(key: 'user', value: user.toString());
      setState(() {
        currentPage = NotesPage();
      });
    } else {
      var token = await _storage.read(key: 'user');
      if (token != null) {
        setState(() {
          currentPage = NotesPage();
        });
      }
    }
  }

  gotonextpage() async {
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => currentPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Image.asset('images/splash.png'),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.redAccent),
            )
          ],
        ),
      ),
    );
  }
}

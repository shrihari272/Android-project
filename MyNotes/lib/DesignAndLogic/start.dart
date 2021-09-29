import 'package:calculator/DesignAndLogic/singUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'NotesPage.dart';
import 'loding.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  var _controller1 = TextEditingController();
  var _reset = TextEditingController();
  var _controller2 = TextEditingController();
  bool _secure = true;
  String _email = '';
  String _password = '';
  var _error1, _error2;
  bool loading = false;
  final snackBar1 = SnackBar(
    content: const Text('Username or Password incorrect'),
  );
  final snackBar2 = SnackBar(
    content: const Text('Check your internet connection'),
  );
  final snackBar3 = SnackBar(
    content: const Text('Invalid Email'),
  );
  final snackBar4 = SnackBar(
    content: const Text('Reset password request is sent to email'),
  );
  final snackBar5 = SnackBar(
    content: const Text('Invalid email or check internet connection'),
  );
  var mainColor = Colors.black;

  _islogged() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NotesPage()));
  }

  loginLog() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      _islogged();
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      } else
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 90),
          child: Text(
            'My Notes',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: _controller1,
        scrollPadding: EdgeInsets.all(10.0),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent)),
            errorText: _error1,
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
            )
            // border: OutlineInputBorder(),
            ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: _controller2,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent)),
            errorText: _error2,
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              color: Colors.redAccent,
              icon: Icon(_secure
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  _secure = !_secure;
                });
              },
            )),
        obscureText: _secure,
      ),
    );
  }

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () {
            resetPass();
          },
          child: Row(
            children: [
              Text(
                "Forgot Password",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height / 55,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 1.4 * (MediaQuery.of(context).size.height / 20),
            width: 5 * (MediaQuery.of(context).size.width / 10),
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                primary: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                if (_controller1.text == '' ||
                    !(_controller1.text.contains('@') &&
                        _controller1.text.contains('.'))) {
                  setState(() {
                    _error1 = 'Enter a valid email';
                  });
                } else {
                  setState(() {
                    _error1 = null;
                    _email = _controller1.text;
                  });
                }
                if (_controller2.text.length < 5) {
                  setState(() {
                    _error2 = 'Atleat 5 character required';
                  });
                } else {
                  setState(() {
                    _error2 = null;
                    _password = _controller2.text;
                  });
                }
                if (_error1 == null && _error2 == null) loginLog();
              },
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: MediaQuery.of(context).size.height / 45,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  resetPass() {
    Get.defaultDialog(
      titleStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'FiraSans',
        fontWeight: FontWeight.bold,
      ),
      title: 'Reset  password',
      backgroundColor: Colors.grey[800],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _reset,
              scrollPadding: EdgeInsets.all(10.0),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@example.com',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent)),
                labelStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              reset();
            },
            child: Text('Reset'),
            style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
          )
        ],
      ),
    );
  }

  reset() async {
    if (_reset.text == '' ||
        !(_reset.text.contains('@') && _reset.text.contains('.'))) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _reset.text);
        ScaffoldMessenger.of(context).showSnackBar(snackBar4);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar5);
      }
    }
    Get.back();
    _reset.clear();
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                _buildForgetPasswordButton(),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? Load()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.grey[900],
              body: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(70),
                          bottomRight: const Radius.circular(70),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _buildLogo(),
                      _buildContainer(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildSignUpBtn(),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

import 'package:calculator/DesignAndLogic/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'NotesPage.dart';
import 'loding.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();
  var _controller3 = TextEditingController();
  bool _secure = true;
  String _email = '';
  String _password = '';
  var _error1;
  var _error2;
  bool loading = false;
  final snackBar = SnackBar(
    content: const Text('Check your internet connection'),
  );
  var mainColor = Colors.black;

  loginReg() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NotesPage()));
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          loading = false;
          _error2 = 'The password provided is too weak.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          loading = false;
          _error1 = 'The account already exists for that email.';
        });
      } else if (e.code == 'network-request-failed') {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
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
    return Column(
      children: [
        Padding(
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
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            controller: _controller3,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent)),
              errorText: _error2,
              labelText: 'Confirm',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ),
            obscureText: _secure,
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
                } else if (!(_controller2.text == _controller3.text)) {
                  setState(() {
                    _error2 = 'No match';
                  });
                } else {
                  setState(() {
                    _error2 = null;
                    _password = _controller2.text;
                  });
                }
                if (_error1 == null && _error2 == null) loginReg();
              },
              child: Text(
                "Sign up",
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

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
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
                      "Register",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                SizedBox(
                  height: 20.0,
                ),
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
                  context, MaterialPageRoute(builder: (context) => Start()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Login',
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

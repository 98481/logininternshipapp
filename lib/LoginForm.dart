import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:internshipapp/Authentication/authentication.dart';
import 'package:internshipapp/RegisterForm.dart';
import 'package:internshipapp/main.dart';
import 'package:internshipapp/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final String username;

  LoginPage({Key key, this.username}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  final _key = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  User user;

  TextEditingController _emailContoller = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //height: MediaQuery.of(context).size.height,
      body: SingleChildScrollView(

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blueGrey,
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _emailContoller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return 'Please enter a valid email Address';
                            }
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white,),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                              ),),
                            style: TextStyle(color: Colors.white,),

                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isHidden,

                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password cannot be empty';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffix: InkWell(
                                onTap: _toggleVisibility,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,color: Colors.white,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                              ),),
                              style: TextStyle(color: Colors.white,),

                        ),
                        SizedBox(height: 5),
                        FlatButton(
                          child: Text('Not registerd? Sign up'),
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => RegisterPage(),),
                            );
                          },
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              child: Text('Login'),
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  bool shouldNavigate = await signIn(_emailContoller.text, _passwordController.text);
                                  user = auth.currentUser;
                                  await user.reload();
                                  if (shouldNavigate) {
                                    if(user.emailVerified) {
                                      SharedPreferences prefs = await SharedPreferences
                                          .getInstance();
                                      prefs?.setBool("isLoggedIn", true);
                                      Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            MyHomePage(),),);
                                    }
                                  }
                                }
                              },
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),);
  }
}

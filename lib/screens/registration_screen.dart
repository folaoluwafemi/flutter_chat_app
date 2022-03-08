import 'package:chat_app_flutter/screens/groups_screen.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  void getCurrentUser() {
    try {
      User? _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
    } catch (e) {
      print(e);
    }
  }

  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    getCurrentUser();
    // print(loggedInUser!.email);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 120),
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'images/chat_logo.png',
                          height: 200,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    AuthTextField(
                      onChanged: (value) {
                        email = value;
                      },
                      isEmail: true,
                      hintTitle: 'Enter your Email',
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    AuthTextField(
                      onChanged: (value) {
                        password = value;
                      },
                      isPassword: true,
                      hintTitle: 'Enter your Password',
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    AuthTextField(
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      isPassword: true,
                      hintTitle: 'Confirm Password',
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    RoundEdgeButton(
                      () async {
                        print("email: $email \n password: $password");

                        if (password == confirmPassword) {
                          final userCredentials =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (userCredentials != null) {
                            loggedInUser = _auth.currentUser;
                            Navigator.of(context).pushNamed(GroupScreen.id);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Check the passwords'),
                            ),
                          );
                        }
                      },
                      child: const Text('Register'),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}

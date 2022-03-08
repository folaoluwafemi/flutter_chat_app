import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool _showProgressIndicator = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => SafeArea(
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: _showProgressIndicator,
              child: SingleChildScrollView(
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
                    RoundEdgeButton(
                      () async {
                        print("email: $email \n password: $password");
                        setState(() {
                          _showProgressIndicator = true;
                        });
                        final _userCredentials =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (_userCredentials != null) {
                          Navigator.of(context).pushNamed(ChatScreen.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Unable to login'),
                            ),
                          );
                        }
                        setState(() {
                          _showProgressIndicator = false;
                        });
                      },
                      color: Colors.blueAccent,
                      child: const Text('Login'),
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

import 'package:chat_app_flutter/screens/groups_screen.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:chat_app_flutter/utils/forms.dart';
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
                  LoginForm(
                    auth: _auth,
                    progressIndicator: (value) {
                      setState(() {
                        _showProgressIndicator = value;
                      });
                    },
                    navigate: () {
                      Navigator.of(context).pushNamed(GroupScreen.id);
                    },
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(error),
                        ),
                      );
                    },
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

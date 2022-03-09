import 'package:chat_app_flutter/screens/groups_screen.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:chat_app_flutter/utils/forms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  bool isLoading = false;

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
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
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
                    RegistrationForm(
                      navigate: () {
                        Navigator.of(context).pushNamed(GroupScreen.id);
                      },
                      onError: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                          ),
                        );
                      },
                      progressIndicator: (value){
                        setState(() {
                          isLoading = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

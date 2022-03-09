import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom_widgets.dart';
import 'utils.dart';

class AuthTextField extends StatelessWidget {
  final bool? isPassword;
  final String? hintTitle;
  final BoxConstraints? constraints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? isEmail;
  final FormFieldValidator? validate;
  final TextEditingController? controller;
  final String? errorText;

  const AuthTextField({
    @required this.onChanged,
    this.onSubmitted,
    @required this.hintTitle,
    this.constraints,
    this.isPassword,
    this.isEmail,
    this.validate,
    this.controller,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: TextFormField(
            controller: controller,
            validator: validate,
            keyboardType: (isEmail == null) ? null : TextInputType.emailAddress,
            obscureText: isPassword ?? false,
            textAlign: TextAlign.center,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            cursorHeight: 20,
            decoration: authInputDecoration().copyWith(
              hintText: hintTitle,
              errorText: errorText,
            )),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final FirebaseAuth auth;
  final Function(bool value) progressIndicator;
  final VoidCallback navigate;
  final Function(String error) onError;

  const LoginForm({
    required this.auth,
    required this.progressIndicator,
    required this.navigate,
    required this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = auth;
    String email = '';
    String password = '';

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
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
              progressIndicator(true);

              final _userCredentials = await _auth
                  .signInWithEmailAndPassword(email: email, password: password)
                  .catchError((error) {
                var newError = error as FirebaseAuthException;

                progressIndicator(false);
                onError(newError.code);
                _formKey.currentState!.validate();
              });

              if (_userCredentials != null) {
                navigate();
                progressIndicator(false);
              }
            },
            color: Colors.blueAccent,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final VoidCallback navigate;
  final Function(String error) onError;
  final Function(bool value) progressIndicator;

  const RegistrationForm({
    required this.navigate,
    required this.onError,
    required this.progressIndicator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    String confirmPassword = '';
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _confirmPasswordController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            controller: _confirmPasswordController,
            isPassword: true,
            hintTitle: 'Confirm Password',
            validate: (newConfirmPassword) {
              if (newConfirmPassword == password) {
                return 'Passwords do not match';
              }
              return 'passwords do not match';
            },
          ),
          const SizedBox(
            height: 42,
          ),
          RoundEdgeButton(
            () async {
              if (password == confirmPassword) {
                progressIndicator(true);

                final userCredentials = await _auth
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .catchError((error) {
                  var registrationError = error as FirebaseAuthException;

                  progressIndicator(false);
                  onError(registrationError.code);
                });

                if (userCredentials != null) {
                  progressIndicator(false);
                  navigate();
                }
              } else {
                onError('Check the passwords');

                progressIndicator(false);
              }
            },
            child: const Text('Register'),
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

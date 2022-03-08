import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_controller);

    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
          key: _globalKey,
          backgroundColor: _animation.value,
          body: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'images/chat_logo.png',
                        height: 60,
                      ),
                    ),
                    TypewriterAnimatedTextKit(
                      text: const ['Flash Chat'],
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 45.0,
                      ),
                      isRepeatingAnimation: false,
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
                const Spacer(),
                RoundEdgeButton(
                  () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: const Text("Login"),
                  color: Colors.blueAccent,
                ),
                RoundEdgeButton(
                  () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  color: Colors.blue,
                  child: const Text('Register'),
                ),
                const SizedBox(
                  height: 100.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:chat_app_flutter/models/models.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/screens/groups_screen.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/screens/registration_screen.dart';
import 'package:chat_app_flutter/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashChatFirebaseApp());
}

class FlashChatFirebaseApp extends StatelessWidget {
  const FlashChatFirebaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const FlashChatApp();
        }
        return const CircularProgressIndicator(
          color: Colors.blueAccent,
        );
      },
    );
  }
}

class FlashChatApp extends StatelessWidget {
  const FlashChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == WelcomeScreen.id) {
          return MaterialPageRoute(builder: (context) => const WelcomeScreen());
        }
        if (settings.name == GroupScreen.id) {
          return MaterialPageRoute(builder: (context) => const GroupScreen());
        }
        if (settings.name == LoginScreen.id) {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
        if (settings.name == RegistrationScreen.id) {
          return MaterialPageRoute(
              builder: (context) => const RegistrationScreen());
        }
        if (settings.name == ChatScreen.id) {
          GroupChatArgument newArgs = settings.arguments as GroupChatArgument;

          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              args: newArgs,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('unknown named route'),
              ),
            ),
          );
        }
      },
    );
  }
}

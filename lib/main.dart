import 'package:chat_app_flutter/screens/chat_screen.dart';
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
//
// class FlashChat extends StatelessWidget {
//   const FlashChat({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return WidgetsApp(
//       color: Colors.white,
//       // theme: ThemeData.dark().copyWith(
//       //   textTheme: const TextTheme(
//       //     bodyText1: TextStyle(color: Colors.black54),
//       //   ),
//       // ),
//       routes: {
//         WelcomeScreen.id: (context) => const MaterialApp(
//               home: WelcomeScreen(),
//             ),
//         ChatScreen.id: (context) => const MaterialApp(
//               home: ChatScreen(),
//             ),
//         LoginScreen.id: (context) => const MaterialApp(
//               home: LoginScreen(),
//             ),
//         RegistrationScreen.id: (context) => const MaterialApp(
//               home: RegistrationScreen(),
//             ),
//       },
//       initialRoute: WelcomeScreen.id,
//       onGenerateRoute: (settings) => MaterialPageRoute(
//         settings: settings,
//         builder: (context) {
//           return const WelcomeScreen();
//         },
//       ),
//       pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
//         return MaterialPageRoute(builder: builder);
//       },
//     );
//   }
// }

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
        if (settings.name == LoginScreen.id) {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
        if (settings.name == RegistrationScreen.id) {
          return MaterialPageRoute(
              builder: (context) => const RegistrationScreen());
        }
        if (settings.name == ChatScreen.id) {
          return MaterialPageRoute(builder: (context) => const ChatScreen());
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

// class FlashChatNavigator extends StatefulWidget {
//   const FlashChatNavigator({Key? key}) : super(key: key);
//
//   @override
//   _FlashChatNavigatorState createState() => _FlashChatNavigatorState();
// }
//

// class _FlashChatNavigatorState extends State<FlashChatNavigator> {
//   @override
//   Widget build(BuildContext context) {
//     return WidgetsApp(
//       color: Colors.white,
//       home: Navigator(
//         onGenerateRoute: (RouteSettings settings){
//           return MaterialPageRoute(
//             settings: settings,
//             builder: (context) => settings.
//           );
//         },
//         pages: [
//           MaterialPage(child: const WelcomeScreen()),
//           MaterialPage(child: const LoginScreen()),
//           MaterialPage(child: const RegistrationScreen()),
//         ],
//       ),
//     );
//   }
// }

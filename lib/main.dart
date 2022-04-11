import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkedin_clone/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LinkedIn Clone',
              theme: ThemeData(primaryColor: Colors.black),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(
                body: Center(
                  child: Text("Please waiting ..."),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LinkedIn Clone',
              theme: ThemeData(primaryColor: Colors.black),
              darkTheme: ThemeData.dark(),
              home: const Scaffold(
                body: Center(
                  child: Text("An error has occured"),
                ),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'LinkedIn Clone',
            theme: ThemeData(primaryColor: Colors.black),
            darkTheme: ThemeData.dark(),
            home: const UserState(),
          );
        });
  }
}

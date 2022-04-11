import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkedin_clone/auth/login_screen.dart';
import 'package:flutter_linkedin_clone/jobs/jobs_screen.dart';
import 'package:flutter_linkedin_clone/jobs/upload_job.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            debugPrint("user is not logged in yet");
            return const LoginScreen();
          } else if (snapshot.hasData) {
            debugPrint("user is already logged in");
            return JobsScreen();
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("An Error has occured. Try again later"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong!"),
            ),
          );
        });
  }
}

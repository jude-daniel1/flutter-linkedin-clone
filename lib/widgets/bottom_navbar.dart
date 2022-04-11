import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkedin_clone/jobs/jobs_screen.dart';
import 'package:flutter_linkedin_clone/jobs/upload_job.dart';
import 'package:flutter_linkedin_clone/search/profile_company.dart';
import 'package:flutter_linkedin_clone/search/search_companies.dart';
import 'package:flutter_linkedin_clone/user_state.dart';

// ignore: must_be_immutable
class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;
  BottomNavigationBarForApp({Key? key, required this.indexNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.white,
      backgroundColor: Colors.black,
      buttonBackgroundColor: Colors.white,
      height: 52,
      index: indexNum,
      items: const [
        Icon(
          Icons.list,
          size: 18,
          color: Colors.blue,
        ),
        Icon(
          Icons.search,
          size: 18,
          color: Colors.blue,
        ),
        Icon(
          Icons.add,
          size: 18,
          color: Colors.blue,
        ),
        Icon(
          Icons.person_pin,
          size: 18,
          color: Colors.blue,
        ),
        Icon(
          Icons.exit_to_app,
          size: 18,
          color: Colors.blue,
        ),
      ],
      animationDuration: const Duration(microseconds: 300),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => JobsScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AllWorkersScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UploadJobNow()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userID: uid,
                      )));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }

  void _logout(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white70,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.grey, fontSize: 28),
                  ),
                ),
              ],
            ),
            content: const Text(
              "Do you want to log out from this App ?",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserState()));
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              )
            ],
          );
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkedin_clone/jobs/jobs_screen.dart';
import 'package:flutter_linkedin_clone/widgets/bottom_navbar.dart';
import 'package:flutter_linkedin_clone/widgets/jobs_widgets.dart';

class SearchJob extends StatefulWidget {
  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search for jobs...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
          onPressed: () {
            _clearSearchQuery();
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => JobsScreen()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("jobs")
            .where("jobTitle", isGreaterThanOrEqualTo: searchQuery)
            .where('recruitment', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, index) {
                  return JobWidget(
                    jobTitle: snapshot.data?.docs[index]['jobTitle'],
                    jobDescription: snapshot.data?.docs[index]
                        ['jobDescription'],
                    jobId: snapshot.data?.docs[index]['jobId'],
                    uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                    userImage: snapshot.data?.docs[index]['userImage'],
                    name: snapshot.data?.docs[index]['name'],
                    recruitment: snapshot.data?.docs[index]['recruitment'],
                    email: snapshot.data?.docs[index]['email'],
                    location: snapshot.data?.docs[index]['location'],
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "There is no job",
                ),
              );
            }
          }
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        },
      ),
    );
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }
}

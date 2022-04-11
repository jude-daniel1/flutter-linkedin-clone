import 'package:flutter/material.dart';
import 'package:flutter_linkedin_clone/search/profile_company.dart';
import 'package:url_launcher/url_launcher.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;

  final String phoneNumber;
  String? userImageUrl;

  AllWorkersWidget(
      {Key? key,
      required this.userID,
      required this.userName,
      required this.userEmail,
      required this.phoneNumber,
      required this.userImageUrl})
      : super(key: key);

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(userID: widget.userID),
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
              ),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(widget.userImageUrl ??
                "https://iph.kcmuco.ac.tz/wp-content/uploads/2021/02/mussa-mkumbwa.png"),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Visit Profile",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _mainTo();
          },
          icon: const Icon(
            Icons.mail_outline,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _mainTo() async {
    var mailUrl = 'mailto:${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print("Error");
      throw "Error occured";
    }
  }
}

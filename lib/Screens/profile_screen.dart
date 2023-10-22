import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/Screens/login_screen.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.chatUser});
  final ChatUser chatUser;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

@override
class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * .05),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .05,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .3),
                child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: widget.chatUser.image,
                    errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Text(
                widget.chatUser.email,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
              ),
              TextFormField(
                initialValue: widget.chatUser.name,
                decoration: InputDecoration(
                    label: Text("Name"),
                    hintText: "e.g Ram Kumar",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              TextFormField(
                initialValue: widget.chatUser.about,
                decoration: InputDecoration(
                    label: Text("About"),
                    prefixIcon: Icon(
                      Icons.error_outline,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(MediaQuery.of(context).size.width * .4,
                        MediaQuery.of(context).size.height * .065)),
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text(
                  "UPDATE",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                utils().toast(error.toString());
              });
            },
            label: Text("Log Out"),
            icon: Icon(Icons.logout),
          ),
        ),
      ),
    );
  }
}

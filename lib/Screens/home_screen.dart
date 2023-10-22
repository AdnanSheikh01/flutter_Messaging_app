import 'package:chatting_app/Screens/profile_screen.dart';
import 'package:chatting_app/Widgets/custom_card.dart';
import 'package:chatting_app/Screens/contact_screen.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

@override
class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Messages"),
        // centerTitle: true,

        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            chatUser: list[0],
                          )));
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
              case ConnectionState.active:
                final data = snapshot.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if (list.isNotEmpty) {
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .01),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return CustomCard(chatUser: list[index]);
                      });
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Connection Found!",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactScreen()));
                        },
                        child: Center(
                            child: Text("Start a Chat",
                                style: TextStyle(
                                    fontSize: 20,
                                    decoration: TextDecoration.underline))),
                      )
                    ],
                  );
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ContactScreen()));
          },
          child: const Icon(Icons.chat)),
    ));
  }
}

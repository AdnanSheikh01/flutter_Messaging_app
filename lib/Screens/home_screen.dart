import 'dart:developer';

import 'package:chatting_app/Screens/profile_screen.dart';
import 'package:chatting_app/Widgets/custom_card.dart';
import 'package:chatting_app/Screens/contact_screen.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

@override
class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _issearching = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    Api.SelfInfo();
    Api.UpdateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (Api.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          Api.UpdateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          Api.UpdateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_issearching) {
            setState(() {
              _issearching = !_issearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: _issearching
                ? TextField(
                    decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none),
                    autofocus: true,
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, letterSpacing: .5),
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text("Messages"),
            // centerTitle: true,

            actions: [
              IconButton(
                  icon: Icon(_issearching ? Icons.cancel : Icons.search),
                  onPressed: () {
                    setState(() {
                      _issearching = !_issearching;
                    });
                  }),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                chatUser: Api.me,
                              )));
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          body: StreamBuilder(
              stream: Api.getAllUsers(),
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
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .01),
                          itemCount:
                              _issearching ? _searchList.length : _list.length,
                          itemBuilder: (context, index) {
                            return CustomCard(
                                chatUser: _issearching
                                    ? _searchList[index]
                                    : _list[index]);
                          });
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Connection Found!!",
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
        ),
      ),
    ));
  }
}

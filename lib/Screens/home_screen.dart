import 'dart:developer';
import 'package:chatting_app/Screens/profile_screen.dart';
import 'package:chatting_app/Widgets/custom_card.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/utils/dialogs.dart';
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
                        color: Colors.black, fontSize: 16, letterSpacing: .5),
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _addChatUserDialog();
            },
            label: Text(
              'Add User',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
          ),
          body: StreamBuilder(
            stream: Api.getMyUserId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  );
                case ConnectionState.done:
                case ConnectionState.active:
                  return StreamBuilder(
                    stream: Api.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),
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
                                    top: MediaQuery.of(context).size.height *
                                        .01),
                                itemCount: _issearching
                                    ? _searchList.length
                                    : _list.length,
                                itemBuilder: (context, index) {
                                  return CustomCard(
                                      chatUser: _issearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "No Connection Found!!\n(Add by using below given Button)",
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    ));
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.black,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                autofocus: true,
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.black, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await Api.AddChatUser(email).then((value) {
                          if (!value) {
                            dialogs.showSnackBar(
                                context,
                                'User does not Exists.',
                                Colors.red,
                                EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        .01));
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ))
              ],
            ));
  }
}

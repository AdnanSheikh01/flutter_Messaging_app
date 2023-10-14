import 'package:chatting_app/Pages/custom_card.dart';
import 'package:chatting_app/Screens/contact_screen.dart';
import 'package:chatting_app/models/chat_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Chatmodel> message = [
    Chatmodel(
        name: "Mohd Adnan",
        icon: "person.svg",
        isGroup: false,
        time: "4:00pm",
        currentMessage: "Hi! How are you?"),
    Chatmodel(
        name: "Mohd Aman",
        icon: "person.svg",
        isGroup: false,
        time: "5:00pm",
        currentMessage: "Hi! Did you done the assignmnet?"),
    Chatmodel(
        name: "Friends forever",
        icon: "groups.svg",
        isGroup: true,
        time: "10:00am",
        currentMessage: "Hi, how all are you?"),
    Chatmodel(
        name: "Jamia Hamdard Announcement",
        icon: "groups.svg",
        isGroup: true,
        time: "11:00pm",
        currentMessage: "No class tomorrow"),
    Chatmodel(
        name: "Alam",
        icon: "person.svg",
        isGroup: false,
        time: "7:00am",
        currentMessage: "Hi! Where are you?")
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Messages"),
          // centerTitle: true,
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            // IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            PopupMenuButton<String>(onSelected: (value) {
              print(value);
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: Text("New Group"), value: "New Group"),
                PopupMenuItem(
                  child: Text("Linked devices"),
                  value: "Linked devices",
                ),
                PopupMenuItem(
                    child: Text("Starred Messages"), value: "Starred Messages"),
                PopupMenuItem(child: Text("Settings"), value: "Settings"),
                PopupMenuItem(
                    child: Text("Help & Support"), value: "Help & Support")
              ];
            })
          ],
        ),
        body: ListView.builder(
          itemCount: message.length,
          itemBuilder: ((context, index) => CustomCard(
                chatmodel: message[index],
              )),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext) => ContactScreen()));
            },
            child: Icon(Icons.chat)),
      ),
    );
  }
}

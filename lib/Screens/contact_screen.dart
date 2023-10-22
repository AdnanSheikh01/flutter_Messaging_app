import 'package:chatting_app/Widgets/button_card.dart';
import 'package:chatting_app/Screens/create_group.dart';
import 'package:chatting_app/Widgets/contact_card.dart';
import 'package:chatting_app/models/contact_chat_model.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ContactChatmodel> contacts = [
    ContactChatmodel(name: "Mohd Adnan", status: "A full stack App developer"),
    ContactChatmodel(name: "Sayed Aman", status: "A full stack Web developer"),
    ContactChatmodel(name: "Mohd Alam", status: "A Software Developer"),
    ContactChatmodel(name: "Mohd Affan", status: "A Software Engineer")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "234 contacts",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            PopupMenuButton<String>(onSelected: (value) {
              print(value);
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: Text("Invite a friend"), value: "Invite a friend"),
                PopupMenuItem(
                  child: Text("Contacts"),
                  value: "Contacts",
                ),
                PopupMenuItem(child: Text("Refresh"), value: "Refresh"),
                PopupMenuItem(
                    child: Text("Help & Support"), value: "Help & Support")
              ];
            })
          ],
        ),
        body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: contacts.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreateGroup()));
                    },
                    child: ButtonCard(name: "New Group", icon: Icons.group));
              } else if (index == 1) {
                return ButtonCard(name: "New Contact", icon: Icons.person_add);
              }
              return ContactCard(contact: contacts[index - 2]);
            }));
  }
}

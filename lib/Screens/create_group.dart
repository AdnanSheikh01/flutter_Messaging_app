import 'package:chatting_app/Pages/button_card.dart';
import 'package:chatting_app/models/contact_chat_model.dart';
import 'package:flutter/material.dart';

import '../Pages/contact_card.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ContactChatmodel> contacts = [
    ContactChatmodel(name: "Mohd Adnan", status: "A full stack App developer"),
    ContactChatmodel(name: "Sayed Aman", status: "A full stack Web developer"),
    ContactChatmodel(name: "Mohd Alam", status: "A Software Developer"),
    ContactChatmodel(name: "Mohd Affan", status: "A Software Engineer")
  ];
  List<ContactChatmodel> groups = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Group",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                "Add participants",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
        ),
        body: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    if (contacts[index].select == false) {
                      setState(() {
                        contacts[index].select = true;
                        groups.add(contacts[index]);
                      });
                    } else {
                      setState(() {
                        contacts[index].select = false;
                        groups.remove(contacts[index]);
                      });
                    }
                  },
                  child: ContactCard(contact: contacts[index]));
            }));
  }
}

import 'package:chatting_app/Pages/inside_custom.dart';
import 'package:chatting_app/models/chatmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.chatmodel});
  final Chatmodel chatmodel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InsideCustom(
                      chatmodel: chatmodel,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: SvgPicture.asset(
                chatmodel.isGroup ? "assets/groups.svg" : "assets/person.svg",
                color: Colors.white,
                height: 32,
              ),
              // backgroundColor: Colors.blueGrey,
            ),
            trailing: Text(chatmodel.time),
            title: Text(
              chatmodel.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [Text(chatmodel.currentMessage)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 80),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}

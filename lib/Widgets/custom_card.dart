import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/Screens/message_chat_screen.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InsideCustom(
                        chatUser: widget.chatUser,
                      )));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.height * .3),
            child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: widget.chatUser.image,
                errorWidget: (context, url, error) => CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    )),
          ),
          title: Text(
            widget.chatUser.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [Text(widget.chatUser.about)],
          ),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}

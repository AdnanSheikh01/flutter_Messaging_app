import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/Screens/message_chat_screen.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/utils/date_util.dart';
// import 'package:chatting_app/utils/dialogs.dart';
import 'package:chatting_app/utils/profie_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  Messages? _messages;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .01),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          chatUser: widget.chatUser,
                        )));
          },
          child: StreamBuilder(
              stream: Api.LastMessages(widget.chatUser),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Messages.fromJson(e.data())).toList() ??
                        [];
                if (list.isNotEmpty) {
                  _messages = list[0];
                }
                return ListTile(
                    leading: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => ProfileDialog(
                                  user: widget.chatUser,
                                ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .03),
                        child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.height * .055,
                            height: MediaQuery.of(context).size.height * .055,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: widget.chatUser.image,
                            errorWidget: (context, url, error) => CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                )),
                      ),
                    ),
                    title: Text(
                      widget.chatUser.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Flexible(
                          child: Text(
                            _messages != null
                                ? _messages!.type == Type.image
                                    ? 'Photo'
                                    : _messages!.msg
                                : widget.chatUser.about,
                          ),
                        )
                      ],
                    ),
                    trailing: _messages == null
                        ? null
                        : _messages!.read.isEmpty &&
                                _messages!.fromID != Api.user.uid
                            ? Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : Text(
                                MyDateUtil.getLastMessageTime(
                                    context, _messages!.sent),
                                style: TextStyle(color: Colors.black54),
                              ));
              })),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Messages message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.message.fromID
        ? _SendMessages()
        : _ReceiveMessages();
  }

// receive from another user
  Widget _ReceiveMessages() {
    if (widget.message.read.isEmpty) {
      Api.updateMessageReadStatus(widget.message);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          // color: Colors.grey[500],
          child: Stack(children: [
            Padding(
              padding: widget.message.type == Type.text
                  ? EdgeInsets.only(left: 10, right: 60, top: 10, bottom: 20)
                  : EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 25),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        imageUrl: widget.message.msg,
                        errorWidget: (context, url, error) => Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 4,
              right: 10,
              child:
                  Text(MyDateUtil.getFormatTime(context, widget.message.sent),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      )),
            )
          ]),
        ),
      ),
    );
  }

// our message sent to another user
  Widget _SendMessages() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: Colors.blue[100],
          child: Stack(children: [
            Padding(
              padding: widget.message.type == Type.text
                  ? EdgeInsets.only(left: 10, right: 60, top: 10, bottom: 20)
                  : EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 25),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        imageUrl: widget.message.msg,
                        errorWidget: (context, url, error) => Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 4,
              right: 10,
              child: Row(
                children: [
                  Text(MyDateUtil.getFormatTime(context, widget.message.sent),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  widget.message.read.isEmpty
                      ? Icon(
                          Icons.done_all_rounded,
                          size: 17,
                          color: Colors.grey[700],
                        )
                      : Icon(
                          Icons.done_all_rounded,
                          size: 17,
                          color: Colors.green,
                        )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

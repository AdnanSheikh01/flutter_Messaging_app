import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/utils/date_util.dart';
import 'package:chatting_app/utils/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Messages message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Api.user.uid == widget.message.fromID;
    return InkWell(
        onLongPress: () {
          _bottomSheet(isMe);
        },
        child: isMe ? _SendMessages() : _ReceiveMessages());
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

  void _bottomSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return ListView(shrinkWrap: true, children: [
          Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * .015,
                  horizontal: MediaQuery.of(context).size.width * .3),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          widget.message.type == Type.text
              ? _optionItem(Icon(Icons.copy), "Copy Message", () async {
                  await Clipboard.setData(
                          ClipboardData(text: widget.message.msg))
                      .then((value) {
                    Navigator.pop(context);

                    dialogs.showSnackBar(
                        context,
                        "Text Copied!",
                        Colors.green,
                        EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * .09));
                  });
                })
              : _optionItem(Icon(Icons.download), "Save Image", () async {
                  try {
                    var response = await Dio().get(widget.message.msg,
                        options: Options(responseType: ResponseType.bytes));
                    await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                      quality: 60,
                      name: "Chat",
                    );
                    Navigator.pop(context);
                    dialogs.showSnackBar(
                        context,
                        "Image Saved Sucessfully",
                        Colors.green,
                        EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * .09));
                  } catch (e) {
                    log('Error while Saving: $e');
                  }
                }),
          if (isMe)
            _optionItem(
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                "Delete Message(From everyone)", () {
              Api.deleteMessage(widget.message).then((value) {
                Navigator.pop(context);
                dialogs.showSnackBar(
                    context,
                    "Deleted",
                    Colors.red,
                    EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * .09));
              });
            }),
          if (isMe)
            _optionItem(
                Icon(Icons.arrow_outward_rounded),
                'Sent at: ${MyDateUtil.getMessageTime(context, widget.message.sent)}',
                () {}),
          if (isMe)
            _optionItem(
                Icon(Icons.remove_red_eye_rounded),
                widget.message.read.isEmpty
                    ? "Read at: Not seen yet"
                    : "Read at: ${MyDateUtil.getMessageTime(context, widget.message.sent)}",
                () {})
        ]);
      },
    );
  }
}

class _optionItem extends StatelessWidget {
  const _optionItem(this.icon, this.name, this.tap);
  final Icon icon;
  final String name;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .05,
            top: MediaQuery.of(context).size.width * .015,
            bottom: MediaQuery.of(context).size.width * .03),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              "   $name",
              style: TextStyle(fontSize: 15, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}

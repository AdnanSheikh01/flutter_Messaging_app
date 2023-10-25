import 'package:chatting_app/models/message.dart';
import 'package:flutter/material.dart';

class ReceiveMessage extends StatefulWidget {
  const ReceiveMessage({super.key, required this.message});
  final Messages message;

  @override
  State<ReceiveMessage> createState() => _ReceiveMessageState();
}

class _ReceiveMessageState extends State<ReceiveMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          // color: Colors.grey[500],
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 60, top: 10, bottom: 20),
              child: Text(
                widget.message.msg,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 10,
              child: Text("12:05pm",
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
}

import 'package:flutter/material.dart';

class SendMessage extends StatelessWidget {
  const SendMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: Colors.blue[100],
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 60, top: 10, bottom: 20),
              child: Text(
                "Hello",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 10,
              child: Row(
                children: [
                  Text("12:00pm",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  Icon(
                    Icons.done_all_rounded,
                    size: 17,
                    color: Colors.green,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

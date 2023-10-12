import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/chatmodel.dart';

class InsideCustom extends StatefulWidget {
  const InsideCustom({super.key, required this.chatmodel});
  final Chatmodel chatmodel;

  @override
  State<InsideCustom> createState() => _InsideCustomState();
}

class _InsideCustomState extends State<InsideCustom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 90,
        titleSpacing: 7,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            CircleAvatar(
              child: SvgPicture.asset(
                widget.chatmodel.isGroup
                    ? "assets/groups.svg"
                    : "assets/person.svg",
                color: Colors.white,
                height: 32,
                width: 32,
              ),
              radius: 20,
            ),
          ],
        ),
        title: InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatmodel.name,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                "last seen today at 12:00am",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          PopupMenuButton<String>(onSelected: (value) {
            print(value);
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(child: Text("View Contact"), value: "View Contact"),
              PopupMenuItem(
                child: Text("Mute Notification"),
                value: "Mute Notification",
              ),
              PopupMenuItem(child: Text("Search"), value: "Search"),
              PopupMenuItem(child: Text("Delete"), value: "Delete"),
              PopupMenuItem(
                  child: Text("Help & Support"), value: "Help & Support")
            ];
          })
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              ListView(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      // height: MediaQuery.of(context).size.height,
                      child: Card(
                        margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a Message",
                              prefixIcon: IconButton(
                                icon: Icon(Icons.emoji_emotions),
                                onPressed: () {},
                              ),
                              contentPadding: EdgeInsets.all(5),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.attach_file))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8, right: 5, left: 2),
                      child: CircleAvatar(
                        radius: 25,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

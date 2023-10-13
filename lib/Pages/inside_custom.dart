import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  TextEditingController _controller = TextEditingController();
  bool show = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

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
        child: WillPopScope(
          child: Stack(
            children: [
              ListView(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          // height: MediaQuery.of(context).size.height,
                          child: Card(
                            margin:
                                EdgeInsets.only(left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: TextFormField(
                              controller: _controller,
                              focusNode: focusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a Message",
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.emoji_emotions),
                                    onPressed: () {
                                      focusNode.unfocus();
                                      focusNode.canRequestFocus = false;
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (builder) =>
                                                BottomSheet());
                                      },
                                      icon: Icon(Icons.attach_file))),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 8, right: 5, left: 2),
                          child: CircleAvatar(
                            radius: 25,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                    show ? EmojiSelect() : Container(),
                  ],
                ),
              ),
            ],
          ),
          onWillPop: () {
            if (show) {
              setState(() {
                show = false;
              });
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
        ),
      ),
    );
  }

  Widget EmojiSelect() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .35,
      child: EmojiPicker(
        config: const Config(columns: 7),
        textEditingController: TextEditingController(),
        onEmojiSelected: (category, emoji) {
          print(emoji);
          _controller.text = _controller.text + emoji.emoji;
        },
      ),
    );
  }

  Widget BottomSheet() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(10),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconsCreate(Icons.insert_drive_file, Colors.indigo, "Document"),
              SizedBox(
                width: 30,
              ),
              IconsCreate(Icons.camera_alt, Colors.pink, "Camera"),
              SizedBox(
                width: 30,
              ),
              IconsCreate(Icons.insert_photo, Colors.purple, "Gallery"),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconsCreate(Icons.headphones, Colors.amber, "Audio"),
              SizedBox(
                width: 30,
              ),
              IconsCreate(Icons.location_on, Colors.teal, "Location"),
              SizedBox(
                width: 30,
              ),
              IconsCreate(Icons.person, Colors.blue, "Contact"),
              SizedBox(
                width: 30,
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget IconsCreate(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(text)
        ],
      ),
    );
  }
}

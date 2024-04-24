// import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/Screens/message_card.dart';
import 'package:chatting_app/Screens/view_profile_screen.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/utils/date_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isUploading = false;
  TextEditingController _controller = TextEditingController();
  List<Messages> _list = [];
  bool show = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
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
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewProfileScreen(
                              chatUser: widget.chatUser,
                            )));
              },
              child: StreamBuilder(
                  stream: Api.getUsersInfo(widget.chatUser),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    final list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    return Row(children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          )),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .03),
                        child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.height * .055,
                            height: MediaQuery.of(context).size.height * .055,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: list.isNotEmpty
                                ? list[0].image
                                : widget.chatUser.image,
                            errorWidget: (context, url, error) => CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list.isNotEmpty
                                ? list[0].name
                                : widget.chatUser.name,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : MyDateUtil.LastActiveTime(
                                        context: context,
                                        LastActive: list[0].lastActive,
                                      )
                                : MyDateUtil.LastActiveTime(
                                    context: context,
                                    LastActive: widget.chatUser.lastActive),
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54),
                          )
                        ],
                      ),
                    ]);
                  }),
            ),
          ),
          // ignore: deprecated_member_use
          body: WillPopScope(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Api.getAllMessages(widget.chatUser),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return SizedBox();
                        case ConnectionState.done:
                        case ConnectionState.active:
                          final data = snapshot.data?.docs;

                          _list = data
                                  ?.map((e) => Messages.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .01),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "Say Hello!! 👋",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                _chatInput(),
                show ? EmojiSelect() : Container(),
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
      ),
    );
  }

  Widget EmojiSelect() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .35,
      child: EmojiPicker(
        textEditingController: TextEditingController(),
        onEmojiSelected: (category, emoji) {
          print(emoji);
          _controller.text = _controller.text + emoji.emoji;
        },
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 60,
          child: Card(
            margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: TextFormField(
              controller: _controller,
              focusNode: focusNode,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type a Message...",
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
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image from gallery.
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          setState(() {
                            _isUploading = true;
                          });
                          log('Image Path: ${i.path}');
                          Api.SendImageChat(widget.chatUser, File(i.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.photo,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image from camera.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _isUploading = true;
                          });

                          Api.SendImageChat(widget.chatUser, File(image.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8, right: 5, left: 2),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black,
            child: IconButton(
              onPressed: () {
                if (_controller.text.trim().isEmpty) {
                  _controller.clear();
                  return;
                } else if (_list.isEmpty) {
                  Api.SendFirstMessage(
                      widget.chatUser, _controller.text.trim(), Type.text);
                } else {
                  Api.SendMessage(
                      widget.chatUser, _controller.text.trim(), Type.text);
                }
                _controller.text = '';
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

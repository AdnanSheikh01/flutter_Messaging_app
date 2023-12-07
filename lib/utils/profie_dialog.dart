import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/Screens/view_profile_screen.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        height: MediaQuery.of(context).size.height * .35,
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width * .09,
              top: MediaQuery.of(context).size.height * .075,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .25),
                child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width * .5,
                    // height: MediaQuery.of(context).size.height * .5,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: user.image,
                    errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        )),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * .04,
              top: MediaQuery.of(context).size.height * .02,
              width: MediaQuery.of(context).size.width * .55,
              child: Text(
                user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
                right: 8,
                top: 4,
                child: MaterialButton(
                  minWidth: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewProfileScreen(chatUser: user)));
                  },
                  child: Icon(
                    Icons.info_outline,
                    size: 28,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

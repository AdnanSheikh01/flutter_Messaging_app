import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(.9),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        height: MediaQuery.of(context).size.height * .3,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(
                //     MediaQuery.of(context).size.height * .25),
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
            )
          ],
        ),
      ),
    );
  }
}

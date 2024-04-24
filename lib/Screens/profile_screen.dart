import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/Screens/login_screen.dart';
import 'package:chatting_app/models/Apis.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/utils/dialogs.dart';
import 'package:chatting_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.chatUser});
  final ChatUser chatUser;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

@override
class _ProfileScreenState extends State<ProfileScreen> {
  String? _image;
  final _formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile"),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * .1),
                              child: Image.file(
                                  width:
                                      MediaQuery.of(context).size.height * .2,
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover,
                                  File(_image!)),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * .1),
                              child: CachedNetworkImage(
                                  width:
                                      MediaQuery.of(context).size.height * .2,
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: widget.chatUser.image,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                        child: Icon(CupertinoIcons.person),
                                      )),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _bottomSheet();
                          },
                          elevation: 1,
                          shape: CircleBorder(),
                          child: (Icon(Icons.edit)),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Text(
                    widget.chatUser.email,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .07,
                  ),
                  TextFormField(
                    initialValue: widget.chatUser.name,
                    onSaved: (value) => Api.me.name = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required Field",
                    decoration: InputDecoration(
                        label: Text("Name"),
                        hintText: "e.g Ram Kumar",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  TextFormField(
                    initialValue: widget.chatUser.about,
                    onSaved: (value) => Api.me.about = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required Field",
                    decoration: InputDecoration(
                        label: Text("About"),
                        prefixIcon: Icon(
                          Icons.error_outline,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * .4,
                            MediaQuery.of(context).size.height * .065)),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        Api.UpdateInfo().then(
                          (value) => {
                            dialogs.showSnackBar(
                              context,
                              "Updated Successfully!",
                              Colors.green,
                              EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * .01),
                            ),
                          },
                        );
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    label: Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              dialogs.showProgressBar(context);
              await Api.UpdateActiveStatus(false);
              await Api.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Api.auth = FirebaseAuth.instance;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              }).onError((error, stackTrace) {
                utils().toast(error.toString());
              });
            },
            label: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _bottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Profile Photo",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.pink,
                        child: IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image from camera.
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 80);
                            if (image != null) {
                              log('Image Path: ${image.path}');
                              setState(() {
                                _image = image.path;
                              });
                              Api.updateProfile(File(_image!));
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.camera_alt),
                          color: Colors.white,
                          iconSize: 40,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.indigo,
                        child: IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image from gallery.
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 80);
                            if (image != null) {
                              log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                              setState(() {
                                _image = image.path;
                              });
                              Api.updateProfile(File(_image!));
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.photo),
                          color: Colors.white,
                          iconSize: 40,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

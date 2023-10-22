import 'dart:io';

import 'package:flutter/material.dart';

class AfterClickViewPage extends StatelessWidget {
  const AfterClickViewPage({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.crop_rotate),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150,
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black87,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  maxLines: 5,
                  minLines: 1,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Add a message.....",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.white,
                      ),
                      suffixIcon: CircleAvatar(
                          radius: 25,
                          child: Icon(
                            Icons.check,
                            size: 25,
                          ))),
                ),
              ))
        ]),
      ),
    );
  }
}

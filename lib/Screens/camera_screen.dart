import 'dart:math';

import 'package:camera/camera.dart';
import 'package:chatting_app/Screens/after_click.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool flash = false;
  bool frontCamera = true;
  double tran = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_cameraController));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            flash = !flash;
                          });
                          flash
                              ? _cameraController.setFlashMode(FlashMode.torch)
                              : _cameraController.setFlashMode(FlashMode.off);
                        },
                        icon: Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          XFile path = await _cameraController.takePicture();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AfterClickViewPage(
                                path: path.path,
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.circle_outlined,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                      Transform.rotate(
                        angle: tran,
                        child: IconButton(
                          onPressed: () async {
                            setState(() {
                              frontCamera = !frontCamera;
                              tran = tran + pi;
                            });
                            int camPosition = frontCamera ? 0 : 1;
                            _cameraController = CameraController(
                                cameras[camPosition], ResolutionPreset.high);
                            cameraValue = _cameraController.initialize();
                          },
                          icon: Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Tap for photo",
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

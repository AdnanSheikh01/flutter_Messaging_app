import 'package:camera/camera.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.flash_off,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.circle_outlined,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.flip_camera_android,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
                Text(
                  "Hold for video, Tap for photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}

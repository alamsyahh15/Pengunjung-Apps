import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController cameraController;
  bool isLoading = false;

  Future<void> inilizeCamera() async {
    setState(() => isLoading = true);
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await cameraController.initialize();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    cameraController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<File> getPicture() async {
    try {
      final res = await cameraController.takePicture();
      return File(res.path);
    } catch (e) {
      return null;
    }
  }

  Future changeCamera() async {
    setState(() => isLoading = true);

    var cameras = await availableCameras();
    if (cameraController.description.name != "1") {
      cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    } else {
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    }
    await cameraController.initialize();
    setState(() => isLoading = false);
  }

  Future flashCamera() async {
    try {
      if (cameraController.value.flashMode != FlashMode.torch) {
        await cameraController.setFlashMode(FlashMode.torch);
      } else {
        await cameraController.setFlashMode(FlashMode.off);
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inilizeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ))
          : Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width *
                          cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(top: 50),
                          child: IconButton(
                            icon: Icon(
                              cameraController.value.flashMode !=
                                      FlashMode.torch
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              flashCamera();
                            },
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(top: 50),
                          child: MaterialButton(
                            shape: CircleBorder(),
                            onPressed: () async {
                              if (!cameraController.value.isTakingPicture) {
                                File result = await getPicture();
                                Navigator.pop(context, result);
                              }
                            },
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(top: 50),
                          child: IconButton(
                            icon: Icon(
                              Icons.crop_rotate_sharp,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              changeCamera();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width *
                      cameraController.value.aspectRatio,
                  child: Image.asset(
                    'assets/frame.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
    );
  }
}

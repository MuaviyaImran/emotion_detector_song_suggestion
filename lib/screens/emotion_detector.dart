
import 'dart:async';

import 'package:emosift/models/playlist_model.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/playlist_card.dart';
import 'package:emosift/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

class EmotionDetector extends StatefulWidget {
  const EmotionDetector({Key? key}) : super(key: key);

  @override
  State<EmotionDetector> createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  CameraImage? cameraImage;
  CameraController? _cameraController;
  String output = '';
  bool isModelBusy = false;
  bool isFrontCamera = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  loadCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = isFrontCamera ? cameras[1] : cameras[0];

    _cameraController =
        CameraController(selectedCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    if (mounted) {
      setState(() {
        _cameraController!.startImageStream((imageStream) {
          cameraImage = imageStream;
          runModel();
        });
      });
    }
  }

  toggleCamera() async {
    isFrontCamera = !isFrontCamera;
    loadCamera();
  }

  startTimerToShowButton() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        if (output == "Sad") showButton = true;
      });
    });
  }

  runModel() async {
    if (cameraImage != null && !isModelBusy) {
      isModelBusy = true;

      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true,
        );

        predictions!.forEach((element) {
          setState(() {
            output = element['label'];
          });
        });

        startTimerToShowButton(); // Start timer after getting output
      } catch (e) {
        print('Error running model: $e');
      } finally {
        isModelBusy = false;
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Image(
              height: 120,
              width: 300,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Emotion Detect by Emosift",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Stack(alignment: Alignment.center, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.7,
                child: !_cameraController!.value.isInitialized
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: _cameraController!.value.aspectRatio,
                        height: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
              ),
              Positioned(
                bottom: 16.0,
                child: ElevatedButton(
                  onPressed: () {
                    toggleCamera();
                  },
                  child: Text('${isFrontCamera ? 'Front' : 'Back'} Camera'),
                ),
              ),
            ]),
            Text(
              'Current Mood is: $output',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (showButton && output == "Sad")
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendationSongsPage(
                          title: output, playlists: Playlist.playlists),
                    ),
                  );
                },
                child: Text('Recommendation Songs'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
    super.dispose();
  }
}

class RecommendationSongsPage extends StatelessWidget {
  final String title;
  final List<Playlist> playlists;

  const RecommendationSongsPage(
      {Key? key, required this.title, required this.playlists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800.withOpacity(0.8),
              Colors.blue.shade200.withOpacity(0.8),
            ],
          ),
        ),
        child: Scaffold(
            appBar: AppBar(title: Text('$title Recommendation Nasheed')),
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  const SectionHeader(title: 'Playlists'),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: playlists.length,
                    itemBuilder: ((context, index) {
                      return PlaylistCard(playlist: playlists[index]);
                    }),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => HomeScreen()));
                      },
                      child: Text("Browse more Nasheeds"))
                ]))));
  }
}

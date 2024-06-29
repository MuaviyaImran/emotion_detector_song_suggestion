import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/section_header.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib; // To handle images
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;

import '../models/song_model.dart';
import '../widgets/playlist_card.dart';

class EmotionDetector extends StatefulWidget {
  const EmotionDetector({Key? key}) : super(key: key);

  @override
  State<EmotionDetector> createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  String output = '';
  bool showButton = false;
  bool isImageLoaded = false;
  bool loading = false;
  CameraController? _controller;
  bool _isCameraReady = false;
  late imglib.Image image =
      imglib.Image(300, 300); // Initialize with a default image size
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera(CameraLensDirection.front);
    loadModel();
  }

  Future<void> _initializeCamera(CameraLensDirection direction) async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == direction,
        orElse: () => cameras.first);

    _controller = CameraController(
      camera, ResolutionPreset.medium,
      enableAudio: false, // Disable audio to avoid unnecessary errors
    );
    await _controller!.initialize();

    setState(() {
      _isCameraReady = true;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> _takePicture() async {
    try {
      final XFile? file = await _controller!.takePicture();

      if (file != null) {
        // Process the captured image
        setState(() {
          image = imglib.decodeImage(File(file.path).readAsBytesSync())!;
          isImageLoaded = true;
        });
        _detectEmotion(file.path);
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _detectEmotion(String imagePath) async {
    setState(() {
      loading = true;
    });
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.100.122:5000/detect_emotion'),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
        filename: path.basename(imagePath),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          if (result.isNotEmpty) {
            output = result[0]['dominant_emotion'];
            showButton = true;
            _errorMessage = "";
          } else {
            output = "";
            _errorMessage = "No face detected.";
          }
          loading = false;
        });
      } else {
        setState(() {
          output = "";
          _errorMessage = jsonDecode(response.body)['error'];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        output = "";
        _errorMessage = "Error: $e";
        loading = false;
      });
    }
  }

  void _toggleCamera() {
    if (_controller != null) {
      final CameraLensDirection newDirection =
          _controller!.description.lensDirection == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front;
      _initializeCamera(newDirection);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isImageLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Image(
                height: 120,
                width: 300,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/logo.jpg'),
              ),
              SizedBox(height: 10),
              Text(
                "Emotion Detect by Emosift",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (loading)
                Center(
                  child:
                      CircularProgressIndicator(), // Show a loading indicator while camera is initializing
                )
              else if (output.isNotEmpty)
                Text(
                  'Current Mood is: $output',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              if (showButton)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationSongsPage(
                            title: output, category: output),
                      ),
                    );
                  },
                  child: Text('Recommendation Songs'),
                ),
              if (_errorMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Error: $_errorMessage',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isImageLoaded = false;
                    image = imglib.Image(300, 300);
                    output = '';
                  });
                },
                child: Text('Reupload Image'),
              ),
            ],
          ),
        ),
      );
    } else {
      if (_isCameraReady) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: 100),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 60 / 60,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
              Transform.rotate(
                angle: math.pi / 2,
                child:
                    Image.memory(Uint8List.fromList(imglib.encodePng(image))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleCamera,
                    icon: Icon(Icons.switch_camera),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _takePicture,
                    child: Icon(Icons.camera),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child:
                CircularProgressIndicator(), // Show a loading indicator while camera is initializing
          ),
        );
      }
    }
  }
}

class RecommendationSongsPage extends StatelessWidget {
  final String title;
  final String category;

  const RecommendationSongsPage({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  List<Song> getSongsByCategory(String category) {
    final songsByCategory =
        Song.songs.where((song) => song.category == category).toList();
    songsByCategory.shuffle(); // Shuffle the list to show songs in random order
    print(songsByCategory);
    return songsByCategory;
  }

  @override
  Widget build(BuildContext context) {
    List<Song> filteredSongs = getSongsByCategory(category);

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
        appBar: AppBar(
            title: Text(
          ' Recommended Songs for $title',
        )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SectionHeader(title: 'Songs'),
              filteredSongs.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredSongs.length,
                      itemBuilder: (context, index) {
                        Song song = filteredSongs[index];
                        return InkWell(
                            onTap: () {
                              Get.toNamed('/song', arguments: song);
                            },
                            child: ListTile(
                              leading: Image.asset(song.coverUrl),
                              title: Text(song.title),
                              subtitle: Text(song.description),
                            ));
                      },
                    )
                  : Center(
                      child: Text(
                        'No songs found',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => HomeScreen()));
                },
                child: Text("Browse more Nasheeds"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

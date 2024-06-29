import 'package:emosift/screens/emotion_detector.dart';
import 'package:emosift/splash.dart';
import 'package:emosift/widgets/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/screens.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';

List<CameraDescription>? camera;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera = await availableCameras();
  await Firebase.initializeApp(
      //name: 'BloodBank',
      options: const FirebaseOptions(
          apiKey: "AIzaSyBG8CO_pmel5Mk1wcyKRyzxdkotc5-dm9E",
          authDomain: "emotion-5cc9c.firebaseapp.com",
          projectId: "emotion-5cc9c",
          storageBucket: "emotion-5cc9c.appspot.com",
          messagingSenderId: "682938451403",
          appId: "1:682938451403:web:2d692a0cc71872afd2a24e"));

  runApp(const MyApp());
  Get.put(FavoritesController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: Colors.white,
            ),
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        GetPage(name: '/playlist', page: () => const PlaylistScreen()),
      ],
    );
  }
}

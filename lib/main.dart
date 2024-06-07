import 'package:emosift/screens/emotion_detector.dart';
import 'package:emosift/splash.dart';
import 'package:emosift/widgets/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/screens.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? camera;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera = await availableCameras();

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

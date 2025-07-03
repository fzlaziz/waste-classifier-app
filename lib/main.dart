import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(WasteClassifierApp(cameras: cameras));
}

class WasteClassifierApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const WasteClassifierApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Classifier',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      home: MainScreen(cameras: cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}

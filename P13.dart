import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashlight App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlashlightPage(),
    );
  }
}

class FlashlightPage extends StatefulWidget {
  @override
  _FlashlightPageState createState() => _FlashlightPageState();
}

class _FlashlightPageState extends State<FlashlightPage> {
  late CameraController _controller;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    _controller = CameraController(camera, ResolutionPreset.low);
    await _controller.initialize();
    if (_controller.value.isInitialized) {
      _controller.setFlashMode(FlashMode.off);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlashlight() {
    if (_controller.value.isInitialized) {
      final flashMode = _controller.value.flashMode;
      if (flashMode == FlashMode.off) {
        _controller.setFlashMode(FlashMode.torch);
        setState(() {
          _flashOn = true;
        });
      } else {
        _controller.setFlashMode(FlashMode.off);
        setState(() {
          _flashOn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashlight'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                size: 48,
                color: _flashOn ? Colors.yellow : Colors.grey,
              ),
              onPressed: _toggleFlashlight,
            ),
            SizedBox(height: 16),
            Text(
              _flashOn ? 'Flashlight On' : 'Flashlight Off',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleStreaming,
        child: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
      ),
    );
  }

  void _toggleStreaming() async {
    if (_isStreaming) {
      setState(() {
        _isStreaming = false;
      });
    } else {
      setState(() {
        _isStreaming = true;
      });
      _startStreaming();
    }
  }

  void _startStreaming() async {
    while (_isStreaming) {
      try {
        final image = await _controller.takePicture();
        final imageBytes = await image.readAsBytes();
        _sendFrameToBackend(imageBytes);
        await Future.delayed(Duration(milliseconds: 500));  // Adjust delay as needed
      } catch (e) {
        print('Error capturing frame: $e');
      }
    }
  }

  void _sendFrameToBackend(Uint8List imageBytes) async {
    final uri = Uri.parse('http://127.0.0.1:5000/predict');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/octet-stream'},
      body: imageBytes,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final prediction = responseBody['prediction'];
      print('Prediction: $prediction');
    } else {
      print('Failed to get prediction');
    }
  }
}

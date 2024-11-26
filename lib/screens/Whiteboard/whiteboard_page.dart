import 'dart:ui';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../widgets/constant_app_bar.dart';
import '../../widgets/constant_bottom_nav_bar.dart';
import '../Courses/courses_page.dart';
import '../Home/home_page.dart';
import '../Gamification/games_hub.dart';
import '../Profile/student_profile_screen.dart';

class WhiteboardPage extends StatefulWidget {
  const WhiteboardPage({super.key});

  @override
  _WhiteboardPageState createState() => _WhiteboardPageState();
}

class _WhiteboardPageState extends State<WhiteboardPage> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<List<DrawingPoint>> drawingPoints = [];
  List<List<List<DrawingPoint>>> undoHistory = [];
  List<List<List<DrawingPoint>>> redoHistory = [];

  final List<double> strokeWidths = [3, 5, 8];

  void _onItemTapped(int index) {
    if (index != 1) {
      // 1 is the index for Whiteboard
      Widget page;
      switch (index) {
        case 0:
          page = Courses();
          break;
        case 2:
          page = const HomePage();
          break;
        case 3:
          page = GamesHub();
          break;
        case 4:
          page = const StudentProfileScreen();
          break;
        default:
          return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConstantAppBar(title: "Whiteboard"),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  drawingPoints.add([]);
                  redoHistory.clear();
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  drawingPoints.last.add(
                    DrawingPoint(
                      details.localPosition,
                      Paint()
                        ..color = selectedColor
                        ..isAntiAlias = true
                        ..strokeWidth = strokeWidth
                        ..strokeCap = StrokeCap.round,
                    ),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  undoHistory.add(List.from(drawingPoints));
                });
              },
              child: CustomPaint(
                painter: _DrawingPainter(drawingPoints),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo, color: Color(0xFF1A5F7A)),
                      onPressed: undo,
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo, color: Color(0xFF1A5F7A)),
                      onPressed: redo,
                    ),
                    IconButton(
                      icon: const Icon(Icons.color_lens,
                          color: Color(0xFF1A5F7A)),
                      onPressed: () => _showColorPicker(context),
                    ),
                    _buildStrokeWidthSelector(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF1A5F7A)),
                      onPressed: clear,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConstantBottomNavBar(
        currentIndex: 1,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStrokeWidthSelector() {
    return PopupMenuButton<double>(
      icon: const Icon(Icons.line_weight, color: Color(0xFF1A5F7A)),
      itemBuilder: (BuildContext context) {
        return strokeWidths.map((width) {
          return PopupMenuItem<double>(
            value: width,
            child: Container(
              width: 100,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1A5F7A)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 80,
                height: width,
                color: strokeWidth == width
                    ? const Color(0xFF1A5F7A)
                    : Colors.grey,
              ),
            ),
          );
        }).toList();
      },
      onSelected: (double width) {
        setState(() {
          strokeWidth = width;
        });
      },
    );
  }

  void undo() {
    if (drawingPoints.isNotEmpty) {
      setState(() {
        redoHistory.add(List.from(drawingPoints));
        drawingPoints.removeLast();
        if (undoHistory.isNotEmpty) {
          undoHistory.removeLast();
        }
      });
    }
  }

  void redo() {
    if (redoHistory.isNotEmpty) {
      setState(() {
        undoHistory.add(List.from(drawingPoints));
        drawingPoints = List.from(redoHistory.last);
        redoHistory.removeLast();
      });
    }
  }

  void clear() {
    setState(() {
      if (drawingPoints.isNotEmpty) {
        undoHistory.add(List.from(drawingPoints));
        drawingPoints.clear();
        redoHistory.clear();
      }
    });
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;
  DrawingPoint(this.offset, this.paint);
}

class _DrawingPainter extends CustomPainter {
  final List<List<DrawingPoint>> drawingPoints;
  _DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in drawingPoints) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          stroke[i].offset,
          stroke[i + 1].offset,
          stroke[i].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

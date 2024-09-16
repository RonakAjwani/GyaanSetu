import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SignLanguagePage extends StatelessWidget {
  final String alphabet;
  final String transliteration;

  SignLanguagePage({required this.alphabet, required this.transliteration});

  final Color primaryColor = Color(0xFF1A5F7A);
  final Color secondaryColor = Color(0xFF2E8BC0);
  final Color accentColor = Color(0xFFFFB703);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color textColor = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn "$alphabet"',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Changed to white for better visibility
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme:
            IconThemeData(color: Colors.white), // Changed icon color to white
        elevation: 0, // Added elevation for better separation from the body
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                alphabet,
                                style: GoogleFonts.roboto(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '[$transliteration]',
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/sign_language/$transliteration.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: WhiteboardWidget(transliteration: transliteration),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteboardWidget extends StatefulWidget {
  final String transliteration;

  WhiteboardWidget({required this.transliteration});

  @override
  _WhiteboardWidgetState createState() => _WhiteboardWidgetState();
}

class _WhiteboardWidgetState extends State<WhiteboardWidget> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5; // Changed default to medium thickness
  List<List<DrawingPoint>> drawingPoints = [];
  List<List<List<DrawingPoint>>> undoHistory = [];
  List<List<List<DrawingPoint>>> redoHistory = [];

  final List<double> strokeWidths = [5, 8, 12]; // Even thicker options

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Practice Writing',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5F7A),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/dotted_alphabets/${widget.transliteration}_dotted.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
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
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.undo, color: Color(0xFF1A5F7A)),
                  onPressed: undo,
                ),
                IconButton(
                  icon: Icon(Icons.redo, color: Color(0xFF1A5F7A)),
                  onPressed: redo,
                ),
                IconButton(
                  icon: Icon(Icons.color_lens, color: Color(0xFF1A5F7A)),
                  onPressed: () => _showColorPicker(context),
                ),
                _buildStrokeWidthSelector(),
                IconButton(
                  icon: Icon(Icons.delete, color: Color(0xFF1A5F7A)),
                  onPressed: clear,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeWidthSelector() {
    return PopupMenuButton<double>(
      icon: Icon(Icons.line_weight, color: Color(0xFF1A5F7A)),
      itemBuilder: (BuildContext context) {
        return strokeWidths.map((width) {
          return PopupMenuItem<double>(
            value: width,
            child: Container(
              width: 100,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF1A5F7A)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 80,
                height: width,
                color: strokeWidth == width ? Color(0xFF1A5F7A) : Colors.grey,
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
          title: Text('Select Color'),
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
              child: Text('OK'),
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../widgets/constant_app_bar.dart';

class NumberDetailPage extends StatelessWidget {
  final String number;
  final String text;

  const NumberDetailPage({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantAppBar(title: 'Number - $text'),
      body: Container(
        color: const Color(0xFFF5F5F5),
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
                                number,
                                style: GoogleFonts.roboto(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E8BC0),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '[$text]',
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/numbers/$text.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Image Not Found',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
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
              child: WhiteboardWidget(number: text),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteboardWidget extends StatefulWidget {
  final String number;

  const WhiteboardWidget({super.key, required this.number});

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
      margin: const EdgeInsets.all(16),
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
                color: const Color(0xFF1A5F7A),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/dotted_numbers/${widget.number}_dotted.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
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
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                  icon: const Icon(Icons.color_lens, color: Color(0xFF1A5F7A)),
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
        ],
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

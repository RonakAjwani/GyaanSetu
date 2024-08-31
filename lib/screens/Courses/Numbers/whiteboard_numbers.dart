import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// NumberDetailPage: Displays the selected number, its image, and a whiteboard for tracing
class NumberDetailPage extends StatelessWidget {
  final String number;
  final String text;

  NumberDetailPage({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number - $text',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
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
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Image Not Found',
                              style: GoogleFonts.poppins(
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
            SizedBox(height: 20),
            Text(
              number,
              style: GoogleFonts.poppins(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '[$text]',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 30),
            Divider(thickness: 2, color: Colors.purpleAccent),
            SizedBox(height: 20),
            Expanded(
              child: WhiteboardWidget(number: text),
            ),
          ],
        ),
      ),
    );
  }
}

// WhiteboardWidget: Allows users to trace the selected number
class WhiteboardWidget extends StatefulWidget {
  final String number;

  WhiteboardWidget({required this.number});

  @override
  _WhiteboardWidgetState createState() => _WhiteboardWidgetState();
}

class _WhiteboardWidgetState extends State<WhiteboardWidget> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image for tracing
        Center(
          child: Image.asset(
            'assets/dotted_numbers/${widget.number}_dotted.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tracing Image Not Found',
                      style: GoogleFonts.poppins(
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
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              drawingPoints.add(
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
          onPanUpdate: (details) {
            setState(() {
              drawingPoints.add(
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
              // Add null to break the line
              drawingPoints.add(null);
            });
          },
          child: CustomPaint(
            painter: _DrawingPainter(drawingPoints),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              Slider(
                min: 1,
                max: 20,
                value: strokeWidth,
                onChanged: (val) => setState(() => strokeWidth = val),
                activeColor: Colors.purpleAccent,
                inactiveColor: Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.purpleAccent),
                onPressed: () => setState(() => drawingPoints.clear()),
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          right: 10,
          child: Column(
            children: colors
                .map(
                  (color) => GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// DrawingPoint class to store position and paint properties
class DrawingPoint {
  final Offset offset;
  final Paint paint;
  DrawingPoint(this.offset, this.paint);
}

// Custom painter for the whiteboard
class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  _DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          drawingPoints[i]!.paint,
        );
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [drawingPoints[i]!.offset],
          drawingPoints[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

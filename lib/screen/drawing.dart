import 'package:flutter/material.dart';
import 'dart:ui';

class ResultScreen extends StatelessWidget {
  final String userInput;

  const ResultScreen({Key? key, required this.userInput}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/game.png',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(userInput.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              userInput[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              border: Border.all(
                                color: Colors.black,
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 50),
                HandwritingContainer(width: userInput.length * 116.0, height: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HandwritingContainer extends StatefulWidget {
  final double width;
  final double height;

  const HandwritingContainer({required this.width, required this.height});

  @override
  _HandwritingContainerState createState() => _HandwritingContainerState();
}

class _HandwritingContainerState extends State<HandwritingContainer> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.white, // White background for handwriting area
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              points.add(details.localPosition);
            });
          },
          onPanEnd: (details) {
            points.add(null);
          },
          child: CustomPaint(
            painter: HandwritingPainter(points),
          ),
        ),
      ),
    );
  }
}

class HandwritingPainter extends CustomPainter {
  final List<Offset?> points;

  HandwritingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
import 'package:flutter/material.dart';
import 'gameplay_screen.dart'; // Import the GameplayScreen

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/lobby.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 400), // Adjust this value to move the button down
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameplayScreen()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: HexagonClipper(),
                    child: Container(
                      color: Colors.black,
                      height: 110,
                      width: 110,
                    ),
                  ),
                  ClipPath(
                    clipper: HexagonClipper(),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameplayScreen()),
                          );
                        },
                        child: Container(
                          color: Color.fromARGB(255, 250, 188, 33),
                          height: 100,
                          width: 100,
                          child: Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    path.moveTo(width * 0.5, 0);
    path.lineTo(width, height * 0.25);
    path.lineTo(width, height * 0.75);
    path.lineTo(width * 0.5, height);
    path.lineTo(0, height * 0.75);
    path.lineTo(0, height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
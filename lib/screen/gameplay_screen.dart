import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';
import 'dart:math';
import 'drawing.dart';
import '../screen/data/game_data.dart';



class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  final AudioPlayer _audioPlayer = AudioPlayer();
  late String _currentWord;
  late String _currentAudio;
  // Set initial color to yellow
  List<Color> _inputColors = List.generate(5, (index) => Colors.yellow);
  bool _isAnswerCorrect = false; // Flag to track if the answer is correct

  @override
  void initState() {
    super.initState();
    final randomIndex = Random().nextInt(wordsData.length);
    _currentWord = wordsData[randomIndex]['word']!;
    _currentAudio = wordsData[randomIndex]['audio']!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructionDialog();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  void _showInstructionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 188, 33),
          content: Container(
            width: double.maxFinite,
            height: 700,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'CARA BERMAIN',
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 120),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    '1. Pemain akan mendengar suara suatu kata yang akan di tampilkan.\n'
                    '2. Setelah memdengarkan, pemain akan mengetik kata yang sudah dia dengar.\n'
                    '3. Setelah menebak dengan benar, pemain akan menulis kata satu persatu.\n',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 120),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
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
                          child: Container(
                            color: const Color.fromARGB(255, 255, 217, 122),
                            height: 100,
                            width: 100,
                            child: const Center(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _playAudio() async {
    await _audioPlayer.play(AssetSource(_currentAudio));
  }

  void _checkAnswer() {
    String userInput = _controllers.map((controller) => controller.text).join();
    if (userInput == _currentWord) {
      // Correct answer
      setState(() {
        _inputColors = List.generate(5, (index) => Colors.green);
        _isAnswerCorrect = true; // Set the flag to true
      });
    } else {
      // Incorrect answer
      setState(() {
        _inputColors = List.generate(5, (index) => Colors.red);
        _isAnswerCorrect = false; // Set the flag to false
      });
    }
  }

  void _nextWord() {
    final randomIndex = Random().nextInt(wordsData.length);
    setState(() {
      _currentWord = wordsData[randomIndex]['word']!;
      _currentAudio = wordsData[randomIndex]['audio']!;
      _inputColors = List.generate(5, (index) => Colors.yellow);
      _isAnswerCorrect = false;
      for (var controller in _controllers) {
        controller.clear();
      }
    });
  }

  void _navigateToResultScreen() {
    String userInput = _controllers.map((controller) => controller.text).join();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(userInput: userInput),
      ),
    );
  }

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
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _showInstructionDialog();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: HexagonClipper(),
                    child: Container(
                      color: Colors.black,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  ClipPath(
                    clipper: HexagonClipper(),
                    child: Container(
                      color: const Color.fromARGB(255, 250, 188, 33),
                      height: 50,
                      width: 50,
                      child: const Center(
                        child: Icon(
                          Icons.question_mark,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isAnswerCorrect)
                  const Text(
                    'Berhasil!!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none, // Hide underline
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]')),
                              ],
                              style: const TextStyle(
                                fontSize: 50.0, 
                                fontWeight: FontWeight.bold,
                                ),
                              enabled: !_isAnswerCorrect, // Disable input if answer is correct
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _controllers[index].text = value.toUpperCase();
                                  _controllers[index].selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _controllers[index].text.length),
                                  );

                                  if (index < _focusNodes.length - 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNodes[index + 1]);
                                  } else {
                                    _focusNodes[index].unfocus();
                                  }

                                  // Check if all inputs are filled
                                  bool allFilled = _controllers.every((controller) => controller.text.isNotEmpty);
                                  if (allFilled) {
                                    _checkAnswer();
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _inputColors[index],
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
                GestureDetector(
                  onTap: () {
                    if (_isAnswerCorrect) {
                      _navigateToResultScreen();
                    } else {
                      _playAudio();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _isAnswerCorrect
                          ? Container(
                              color: const Color.fromARGB(255, 250, 188, 33),
                              height: 70,
                              width: 150,
                              child: const Center(
                                child: Text(
                                  'LANJUT',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : ClipPath(
                              clipper: HexagonClipper(),
                              child: Container(
                                color: Colors.black,
                                height: 80,
                                width: 80,
                              ),
                            ),
                      if (!_isAnswerCorrect)
                        ClipPath(
                          clipper: HexagonClipper(),
                          child: Container(
                            color: const Color.fromARGB(255, 250, 188, 33),
                            height: 70,
                            width: 70,
                            child: const Icon(
                              Icons.volume_up,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
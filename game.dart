import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/logic.dart';
import 'package:game/result.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  int _currentQuestion = 0;
  int _timeLeft = 10;
  late Timer _timer;
  bool _gameOver = false;

  final List<ColorQuestion> _questions = [
    ColorQuestion(
      word: "RED",
      color: Colors.blue,
      options: ["Red", "Blue", "Green", "Yellow"],
    ),
    ColorQuestion(
      word: "GREEN",
      color: Colors.red,
      options: ["Red", "Blue", "Green", "Yellow"],
    ),
    ColorQuestion(
      word: "BLUE",
      color: Colors.yellow,
      options: ["Red", "Blue", "Green", "Yellow"],
    ),
    ColorQuestion(
      word: "YELLOW",
      color: Colors.green,
      options: ["Red", "Blue", "Green", "Yellow"],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    setState(() {
      _timeLeft = 10;
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer.cancel();
    setState(() {
      _gameOver = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultsScreen(score: _score, total: _questions.length),
      ),
    );
  }

  void _checkAnswer(String selectedColor) {
    if (_questions[_currentQuestion].color == _colorFromString(selectedColor)) {
      setState(() {
        _score++;
      });
    }
    _nextQuestion();
  }

  Color _colorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQ = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Match Challenge'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Score: $_score'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: _timeLeft / 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            Text(
              'Time Left: $_timeLeft seconds',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            Text(
              currentQ.word,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: currentQ.color,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'What color is the text actually?',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ...currentQ.options
                .map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(option),
                        child: Text(option),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

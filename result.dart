import 'package:flutter/material.dart';
import 'package:game/home.dart';


class ResultsScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultsScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Score',
                style: TextStyle(fontSize: 24, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              Text(
                '$score / $total',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$percentage% correct',
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              LinearProgressIndicator(
                value: score / total,
                backgroundColor: Colors.grey[300],
                color: percentage > 70
                    ? Colors.green
                    : percentage > 40
                    ? Colors.orange
                    : Colors.red,
                minHeight: 20,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

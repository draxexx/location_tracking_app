import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Clock In')),
            ElevatedButton(onPressed: () {}, child: const Text('Clock Out')),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/summary');
              },
              child: Text('Go to Summary Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studentifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Center',
              style: TextStyle(fontSize: 50, color: Colors.blueAccent),
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: Image(
                image: AssetImage('assets/images/ocr.jpeg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

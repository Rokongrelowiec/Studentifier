import 'package:flutter/material.dart';

import '../widgets/custom_snack_bar_content.dart';

class FirstTab extends StatelessWidget {
  const FirstTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomSnackBarContent('This is a custom message'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              );
            },
            child: Text("Show Message"),
          ),
        ],
      ),
    );
  }
}

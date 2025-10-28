import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(4, (index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.pushNamed(context, '/order');
                } else {
                  //暫留待議
                }
              },
              child: Image.asset(
                'assets/images/${index + 1}.png',
                width: 150,
                height: 150,
              ),
            );
          }),
        ),
      ),
    );
  }
}

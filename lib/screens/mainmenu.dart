import 'package:flutter/material.dart';
import './webview.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('點餐系統')),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(4, (index) {
            return GestureDetector(
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/order');
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          url: 'https://docs.google.com/spreadsheets/d/1uvFbdC49s1qm3-SFLasmEMNLSeTP9bG9NMSnl4aEYIU/edit?usp=sharing',
                          title: '點餐紀錄',
                        ),
                      ),
                    );
                    break;
                  default:
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

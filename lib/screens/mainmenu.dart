import 'package:flutter/material.dart';
import './webview.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('點餐系統'),
      actions: [
        ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/admin');
        },
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text("管理員"),
      ),
      ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          url: 'https://docs.google.com/spreadsheets/d/1uvFbdC49s1qm3-SFLasmEMNLSeTP9bG9NMSnl4aEYIU/edit?usp=sharing',
                          title: '點餐紀錄',
                        ),
                      ),
                    );
        },
        icon: const Icon(Icons.table_chart),
        label: const Text("表單回應"),
      )
      ],),
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
                    Navigator.pushNamed(context, '/login');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/team');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/about');
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

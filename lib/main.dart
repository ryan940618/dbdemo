import 'package:flutter/material.dart';
import 'screens/mainmenu.dart';
import 'screens/order.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '點餐系統',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/mainmenu',
      routes: {
        '/mainmenu': (context) => MainMenu(),
        '/order': (context) => OrderPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/mainmenu.dart';
import 'screens/order.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'screens/login.dart';
import 'screens/admin.dart';
import 'screens/about.dart';
import 'screens/team.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
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
        '/login': (context) => LoginPage(),
        '/admin': (context) => AdminPage(),
        '/team': (context) => const TeamPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const HereBro());
}

class HereBro extends StatelessWidget {
  const HereBro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Here Bro',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const Scaffold(body: Center(child: Text('Hello, World!'))),
      debugShowCheckedModeBanner: false,
    );
  }
}

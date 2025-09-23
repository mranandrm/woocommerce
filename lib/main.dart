import 'package:flutter/material.dart';
import 'package:woocommerce/screens/HomeScreen.dart';
import 'package:woocommerce/screens/LoginScreen.dart';
import 'package:woocommerce/screens/ProductScreen.dart';
import 'package:woocommerce/screens/RegisterScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/screens/SettingScreen.dart';
import 'package:woocommerce/screens/auth/LoginScreen.dart';
import 'package:woocommerce/services/UiProvider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(

            debugShowCheckedModeBanner: false,

            title: 'Dark Theme',
            //By default theme setting, you can also set system
            // when your mobile theme is dark the app also become dark

            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,

            //Our custom theme applied
            darkTheme: notifier.isDark ? notifier.darktheme : notifier.lightTheme,

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),

            home: LoginScreen(),

          );
        },
      ),
    );
  }
}
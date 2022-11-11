import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/theme_provider.dart';
import './screens/animated_splash_screen.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    if (inDebug) return ErrorWidget(details.exception);
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error!\n${details.exception}',
        style: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..initialize(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Studentifier',
          themeMode: provider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.orange[300],
              indicatorColor: Colors.orangeAccent[400],
            ),
            textTheme: TextTheme(
              headline1: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: Colors.grey[900],
            navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.black, indicatorColor: Colors.white30),
            drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[850]),
            textTheme: TextTheme(
              headline1: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          home: AnimatedSplashScreen(),
        );
      },
    );
  }
}

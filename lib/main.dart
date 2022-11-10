import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentifier/screens/login_screen.dart';

import './models/theme_provider.dart';
import './screens/animated_splash_screen.dart';

import './screens/home_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider()..initialize(),
          ),
        ],
        child: const MyApp(),
      ),
    );

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

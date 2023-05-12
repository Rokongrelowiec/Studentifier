import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './providers/language_provider.dart';
import './providers/admin_provider.dart';
import './providers/theme_provider.dart';
import './screens/about_the_app_screen.dart';
import './screens/chart_screen.dart';
import './screens/registered_license_plates.dart';
import './screens/animated_splash_screen.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/contact_admin_screen.dart';
import './l10n/l10n.dart';
import './screens/parking_limit_screen.dart';
import './screens/deny_screen.dart';
import './screens/reset_password_screen.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider()..initialize(),
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
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, provider1, provider2, child) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
            ChartScreen.routeName: (_) => ChartScreen(),
            AboutApp.routeName: (_) => AboutApp(),
            RegisteredLicensePlates.routeName: (_) => RegisteredLicensePlates(),
            ContactAdminScreen.routeName: (_) => ContactAdminScreen(),
            ParkingLimitScreen.routeName: (_) => ParkingLimitScreen(),
            DenyScreen.routeName: (_) => DenyScreen(),
            ResetPasswordScreen.routeName: (_) => ResetPasswordScreen(),
          },
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: provider2.locale,
          title: 'Studentifier',
          themeMode: provider1.themeMode,
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

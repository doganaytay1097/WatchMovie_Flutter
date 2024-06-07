import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watch_list/providers/color_theme_data.dart';
import 'package:watch_list/providers/items_data.dart';
import 'package:watch_list/screens/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final colorThemeData = ColorThemeData();
  await colorThemeData.createSharedPref();
  await colorThemeData.loadTheme();

  final itemData = ItemData();
  await itemData.createPrefObject();
  itemData.loadItems();
  itemData.loadCategories();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => itemData),
        ChangeNotifierProvider(create: (context) => colorThemeData),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ColorThemeData>(context).selectedThemeData,
      home: AnimatedSplashScreen(
        splash: Lottie.asset('assets/lottie2.json'), // Lottie animasyon dosyanızın yolu
        nextScreen: MainPage(),
        duration: 2000,
        splashIconSize: 1000,
        backgroundColor: Colors.black,
      ),
    );
  }
}

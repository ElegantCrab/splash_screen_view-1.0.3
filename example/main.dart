import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'SecondScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Normal Logo Splash screen
    Widget example1 = SplashScreenView(
      home: SecondScreen(),
      duration: 3000,
      imageSize: 200,
      imageSrc: "logo.png",
      backgroundColor: Colors.white,
    );

    /// Logo with animated Colorize text
    Widget example2 = SplashScreenView(
      home: SecondScreen(),
      duration: 5000,
      imageSize: 100,
      imageSrc: "logo.png",
      text: "Colorize Text",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    /// Logo with Typer Animated Text example
    Widget example3 = SplashScreenView(
      home: SecondScreen(),
      duration: 3000,
      imageSize: 100,
      imageSrc: "logo.png",
      text: "Typer Animated Text",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    /// Logo with Scale Animated Text example
    Widget example4 = SplashScreenView(
      home: SecondScreen(),
      duration: 3000,
      imageSize: 100,
      imageSrc: "logo.png",
      text: "Scale Animated Text",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    /// Logo with Normal Text example
    Widget example5 = SplashScreenView(
      home: SecondScreen(),
      duration: 3000,
      imageSize: 100,
      imageSrc: "logo.png",
      text: "Normal Text",
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      title: 'Splash screen Demo',
      home: example5,
    );
  }
}


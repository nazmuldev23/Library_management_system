import 'package:flutter/material.dart';
import 'package:library_management_system/screens/Splash_screen.dart';

import '../screens/homescreen.dart';

class LibraryManagementSystem extends StatelessWidget {
  const LibraryManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library_management_system',
      home: SplashScreen(),
      initialRoute: SplashScreen.name,
      onGenerateRoute: (settings) {
        late Widget screen;
        if(settings.name == SplashScreen.name){
          screen = SplashScreen();
        } else if(settings.name == HomeScreen.name){
          screen = HomeScreen();
        }

        return MaterialPageRoute(builder: (ctx)=> screen);
      },

    );
  }
}
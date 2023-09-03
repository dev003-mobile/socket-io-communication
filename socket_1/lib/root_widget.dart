import 'package:flutter/material.dart';

import 'home_screen.dart';

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.black
      ),
      initialRoute: "/",
      routes: {
        "/" :(context) => const HomeScreen()
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:new_flutter_test/Providers/LocationProvider.dart';
import 'package:new_flutter_test/Screens/HomeScreen/HomeScreen.dart';
import 'package:provider/provider.dart';

import 'Constants/ColorConstants.dart';
import 'Screens/RegistrationScreen/RegistrationScreen.dart';
import 'Screens/SplashScreen/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Cinzel",
          primaryColor: PaletteColors.mainAppColor,
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            elevation: 3,
          ),
        ),
        title: 'Flutter New Test',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/registration': (context) => RegistrationScreen(),
        },
      ),
    );
  }
}

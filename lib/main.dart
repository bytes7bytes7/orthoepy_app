import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_accent_app/screens/home_screen.dart';
import 'package:flutter_accent_app/const.dart';
import 'package:flutter_accent_app/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  readFile().then((map) {
    List<String> keys =map.keys.toList();
    if(keys.length==0){
      createDictionary();
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Orthoepy App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        buttonColor: kButtonColor,
        focusColor: kFocusColor,
        backgroundColor: kBackgroundColor,
        errorColor: kErrorColor,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: kBackgroundColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: kBodyTextColor,
            fontSize: 20.0,
          ),
          subtitle1: TextStyle(
              color: kButtonColor, fontSize: 16.0, fontWeight: FontWeight.bold),
          button: TextStyle(
            color: kPrimaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

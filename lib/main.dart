import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';

// import all class files (create one class per page)
import 'home_page.dart';
import 'login_page.dart';
import 'setting_page.dart';
import 'backend_api.dart';



void main() {
  runApp(const FraPodsApp());
}

// Do not create layouts in this file! (main.dart)
// Each Page should have its own file (eg. "the_page.dart").  No spaces and no capital letters.

class FraPodsApp extends StatelessWidget {
  const FraPodsApp({Key? key}) : super(key: key);


  @override
    Widget build(BuildContext context) {

    BackendApi().autoLogIn();

    return ValueListenableBuilder<bool>(
      valueListenable: darkNotifier, 
      builder: (BuildContext context, bool isDark, Widget? child){
        return MaterialApp(
          title: 'FraPods',
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            appBarTheme: AppBarTheme( backgroundColor: blueish(), foregroundColor: Colors.white),
            // primaryColor: Colors.white,
             colorScheme:ColorScheme.light(
              primary: Color(0xff468CE8), 
              primaryVariant: Color(0xFF99C4FD),
              secondary: Color(0xFF424242), 
              secondaryVariant: Color(0xff646464), 
              surface: Color(0xffFFFEF6), 
              background: Colors.white, 
              error: Color(0xffb00020), 
              onPrimary:Colors.black,
              onSecondary: Colors.black, 
              onSurface: Colors.black, 
              onBackground: Colors.black, 
              onError: Colors.white, 
              brightness: Brightness.light,
            )
          ),

          darkTheme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: blueish(),foregroundColor: Colors.white),
            // primarySwatch: generateMaterialColorFromColor(Color(0xFF004AAD)),
            // primaryColor: Colors.white,
            backgroundColor: backgroundColor(),
             colorScheme:ColorScheme.dark(
              primary: Color(0xff0264e3), 
              primaryVariant: Color(0xff5C96E1),
              secondary: Color(0xFF646464), 
              secondaryVariant: Color(0xff909090), 
              surface: Color(0xff424242),
              background: Color(0xff121212),
              error: Color(0xffcf6679), 
              onPrimary: Colors.white, 
              onSecondary: Colors.black, 
              onSurface: Colors.white, 
              onBackground: Colors.white, 
              onError: Colors.black, 
              brightness: Brightness.dark,
            )
          ),

          home: const LoginPage(),

        );
      });
  }
}

// define public methods here:

TextStyle highlightedTextStyle() {
  return TextStyle(
    fontSize: 16,
    color: generateMaterialColorFromColor(Color(0xFF004AAD)),
  );
}

TextStyle titleTextStyle() {
  return TextStyle(
    fontSize: 32,
    color: generateMaterialColorFromColor(Color(0xFF004AAD)),
  );
}

TextStyle normalTextStyle() {
  return TextStyle(
    fontSize: 16,
    //color: generateMaterialColorFromColor(Color(0xFFFFFFFF)),
  );
}

TextStyle normalTextStyle2() {
  return TextStyle(
    fontSize: 18,
    //color: generateMaterialColorFromColor(Color(0xFFFFFFFF)),
  );
}

TextStyle subtitleTextStyle(){
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    //color: Colors.white,
  );
}

Color blueish() {
  return generateMaterialColorFromColor(Color(0xFF004AAD));
}



Color backgroundColor(){
  return Color(0xFF292929);
}


MaterialColor generateMaterialColorFromColor(Color color) {
return MaterialColor(color.value, {
50: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
100: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
200: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
300: Color.fromRGBO(color.red, color.green, color.blue, 0.4),
400: Color.fromRGBO(color.red, color.green, color.blue, 0.5),
500: Color.fromRGBO(color.red, color.green, color.blue, 0.6),
600: Color.fromRGBO(color.red, color.green, color.blue, 0.7),
700: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
800: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
900: Color.fromRGBO(color.red, color.green, color.blue, 1.0),
});
}

final darkNotifier = ValueNotifier<bool>(true);
final loginStatusChangedNotifier = ValueNotifier<bool>(false);
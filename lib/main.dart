import 'package:flutter/material.dart';

// import all class files (create one class per page)
import 'home_page.dart';
import 'login_page.dart';

void main() {
  runApp(const FraPodsApp());
}

// Do not create layouts in this file! (main.dart)
// Each Page should have its own file (eg. "the_page.dart").  No spaces and no capital letters.

class FraPodsApp extends StatelessWidget {
  const FraPodsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FraPods',
      theme: ThemeData(
        primarySwatch: generateMaterialColorFromColor(Color(0xFF004AAD)),
      ),
      //home: const LoginPage(title: 'FraPods - Podcast Sharing'),
      home: const HomePage(username: "username")
    );
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

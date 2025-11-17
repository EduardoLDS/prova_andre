import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prova/pages/home_page.dart';
import 'package:prova/pages/register_pages.dart';
import 'firebase_options.dart';
import 'pages/login_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

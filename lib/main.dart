// lib/main.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blue_ribbon/screens/main_page.dart';
import 'package:blue_ribbon/secrets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:blue_ribbon/screens/library.dart';
import 'route_observer.dart'; // Import the RouteObserver

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure all bindings are initialized

  await Supabase.initialize(url: Secrets().url(), anonKey: Secrets().key());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Gemini.init(apiKey: Secrets().geminiKey());

  // Initialize Hive and open a box for storing book progress
  await Hive.initFlutter();
  await Hive.openBox<int>('bookProgress'); // Box name: 'bookProgress'

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      title: 'Blue Ribbon',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.lexend().fontFamily,
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [routeObserver], // Add the RouteObserver here
    );
  }
}

Future<String?> askGemini(String question) async {
  final gemini = Gemini.instance;

  try {
    final responseStream = gemini.streamGenerateContent(question);

    StringBuffer fullResponse = StringBuffer();

    await for (var response in responseStream) {
      fullResponse.write(response.output); // Collect all parts of the output
    }

    return fullResponse.toString();
  } catch (e) {
    log('streamGenerateContent exception', error: e);

    return 'An error occurred while processing your request.';
  }
}

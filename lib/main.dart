import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blue_ribbon/screens/main_page.dart';
import 'package:blue_ribbon/secrets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:blue_ribbon/screens/library.dart'; // Adjust the import as necessary

Future<void> main() async {
  await Supabase.initialize(url: Secrets().url(), anonKey: Secrets().key());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Gemini.init(apiKey: Secrets().geminiKey());

  WidgetsFlutterBinding.ensureInitialized();

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
      home: const Mainpage(),
      title: 'Blue Ribbon',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.lexend().fontFamily,
        primarySwatch: Colors.blue,
      ),
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

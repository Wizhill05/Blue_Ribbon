// lib/main.dart
import 'dart:convert';
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
import 'package:http/http.dart' as http;

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
  await Hive.openBox<String>('link');
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
  question = "Summarize this text in simple to read english:" + question;

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

Future<String> askServer(String question) async {
  Box<String> linkBox = Hive.box<String>('link');
  final response = await http.post(
    Uri.parse(
        '${linkBox.get("link") ?? Secrets().serverLink()}/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'phi-3.5-mini-instruct',
      'messages': [
        {
          'role': 'system',
          'content': 'Summarize this text in simple to read english:'
        },
        {'role': 'user', 'content': question}
      ],
      'temperature': 0.7,
      'max_tokens': -1,
      'stream': false
    }),
  );
  return jsonDecode(response.body)['choices'][0]['message']['content']
      .toString();
}

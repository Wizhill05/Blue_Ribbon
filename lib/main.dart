import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:blue_ribbon/screens/reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blue_ribbon/screens/main_page.dart';
import 'package:blue_ribbon/secrets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:http/http.dart' as http;
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
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;

  @override
  void initState() {
    super.initState();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      setState(() {
        list = value;
      });
      print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      setState(() {
        list = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (list != null) {
      if (list!.isNotEmpty)  {
        return (MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ReaderPage(
            title: "Received Text",
            data: list!.map((f) => f.value).join(","),
          ),
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: GoogleFonts.lexend().fontFamily,
            primarySwatch: Colors.blue,
          ),
          navigatorObservers: [routeObserver],
        ));
      }
    }

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
  question = "Summarize this text in simple to read english: $question";

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

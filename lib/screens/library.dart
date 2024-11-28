import 'dart:io';

import 'package:blue_ribbon/screens/reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../reusable.dart';
import 'package:hive/hive.dart'; // Import Hive
import 'package:hive_flutter/hive_flutter.dart';
import '../route_observer.dart'; // Import the RouteObserver
import '../elements/book.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with RouteAware {
  List<Map<String, dynamic>> books = []; // Variable to store fetched data
  bool isLoading = true; // Variable to track loading state
  late Box<int> _bookProgressBox; // Hive box for storing book progress

  @override
  void initState() {
    super.initState();
    _bookProgressBox = Hive.box<int>('bookProgress'); // Initialize Hive box
    fetchBooks(); // Fetch books when the widget is initialized
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    ); // Subscribe to RouteObserver
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // Unsubscribe from RouteObserver
    super.dispose();
  }

  // Called when the Library page is visible again after a pop
  @override
  void didPopNext() {
    fetchBooks(); // Refresh the books list
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final data = await supabase.from('books').select();

      setState(() {
        books = data;
        isLoading = false; // Set loading to false after fetching data
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting documents: $e");
      }
      setState(
        () {
          isLoading = false; // Set loading to false even if there's an error
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pdfPicker(context);
        },
        backgroundColor: textCDark,
        foregroundColor: Colors.white,
        child: const Icon(Icons.picture_as_pdf_rounded),
      ),
      backgroundColor: bgC,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    bgC,
                    toColor("b2f7e3"),
                    toColor("6de3c0"),
                  ],
                  stops: const [
                    0,
                    0.3,
                    1
                  ]),
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 120,
              child: Align(
                alignment: const Alignment(-1, 1),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    "Books",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: textCDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Divider(
              color: textCDark,
              thickness: 6,
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              color: Colors.transparent,
              height: MediaQuery.sizeOf(context).height - 130,
              child: isLoading // Check if loading
                  ? Align(
                      alignment: const Alignment(0, -1),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(100, 40, 100, 0),
                        child: Lottie.asset(
                          'assets/Loader.json',
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: books.map(
                          (book) {
                            // Use null-aware operators to handle potential null values
                            final link = book['link'];
                            final title = book['title'] ??
                                'Untitled'; // Default to 'Untitled' if null
                            final bookText = book['text'] ?? '';

                            // Retrieve saved progress or default to 0
                            final progress = _bookProgressBox.get(title) ?? 0;

                            return Book(
                                context, link, title, bookText, progress);
                          },
                        ).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

void pdfPicker(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.isNotEmpty) {
    File file = File(result.files.single.path!);
    final tf = await getPDFText(file.path);
    Navigator.push(
      context,
      _readerRoute("PDF", tf, 0),
    );
    // return file;
  } else {
    // Return null if no file was picked
  }
}

Future<String> getPDFText(String path) async {
  String text = "";
  try {
    text = await ReadPdfText.getPDFtext(path);
  } on PlatformException {
    if (kDebugMode) {
      print('Failed to get PDF text.');
    }
  }
  return text;
}

Route _readerRoute(String title, String data, int progress) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ReaderPage(
      title: title,
      data: data,
      initialProgress: progress,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.ease)),
        child: child,
      );
    },
  );
}

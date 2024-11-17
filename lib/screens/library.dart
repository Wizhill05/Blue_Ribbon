import 'package:blue_ribbon/screens/reader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../reusable.dart';
import './ask.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<Map<String, dynamic>> books = []; // Variable to store fetched data
  bool isLoading = true; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fetch books when the widget is initialized
  }

  Future<void> fetchBooks() async {
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
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: const Align(
                alignment: Alignment(-1, 1),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    "Books",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Divider(
              color: textC,
              thickness: 6,
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.sizeOf(context).height - 130,
              child: isLoading // Check if loading
                  ? Align(
                      alignment: Alignment(0, -1),
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
                        children: books.map((book) {
                          // Use null-aware operators to handle potential null values
                          final link = book['link'];
                          final title = book['title'] ??
                              'Untitled'; // Default to 'Untitled' if null
                          return Book(context, link, title, book['text']);
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

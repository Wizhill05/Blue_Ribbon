import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../reusable.dart';
import '../secrets.dart';
import 'reader.dart'; // Make sure to import the Reader page

class NewsApiPage extends StatefulWidget {
  const NewsApiPage({super.key});

  @override
  State<NewsApiPage> createState() => _NewsApiPageState();
}

class _NewsApiPageState extends State<NewsApiPage> {
  List<Map<String, dynamic>> articles =
      []; // Variable to store fetched articles
  bool isLoading = true; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    fetchNews(); // Fetch news when the widget is initialized
  }

  Future<void> fetchNews() async {
    String apiKey = Secrets().newsKey(); // Replace with your News API key
    String apiUrl =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articlesData = data['articles'];

        setState(() {
          articles = articlesData
              .map((article) => {
                    'title': article['title'] ?? 'No Title',
                    'content': article['content'] ?? '',
                    'urlToImage': article['urlToImage'] ??
                        'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png', // Placeholder image
                  })
              .toList();
          isLoading = false; // Set loading to false after fetching data
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching news: $e");
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
                    toColor("f9ffe3"),
                    toColor("f2ffc4"),
                    toColor("e7ff91"),
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
                alignment: Alignment(-1, 1),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    "News",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color: textCDark),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Divider(
              color: textCDark,
              thickness: 6,
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.sizeOf(context).height - 130,
              child: isLoading
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
                        children: articles.map((article) {
                          return NewsItem(
                            context,
                            article['urlToImage'],
                            article['title'],
                            article['content'],
                          );
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

Widget NewsItem(
    BuildContext context, String imageUrl, String title, String url) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        _ReaderRoute(title, url),
      );
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textCDark,
          width: 5,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                    child: const Center(child: Text('No Image')),
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Route _ReaderRoute(String title, String data) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ReaderPage(title: title, data: data),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.ease)),
        child: child,
      );
    },
  );
}

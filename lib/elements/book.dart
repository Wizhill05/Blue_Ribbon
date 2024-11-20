import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../reusable.dart';
import '../screens/reader.dart';

class Book extends StatefulWidget {
  final String link;
  final String title;
  final String data;

  const Book({
    super.key,
    required this.link,
    required this.title,
    required this.data,
  });

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  late Box<int> bookProgressBox;
  int progress = 0;

  void initState() {
    super.initState();
    bookProgressBox = Hive.box<int>('bookProgress');
    progress = bookProgressBox.get(widget.title) ?? 0;
  }

  bool isBookmarked() {
    setState(() {
      progress = bookProgressBox.get(widget.title) ?? 0;
    });
    return progress > 0;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _ReaderRoute(widget.title, widget.data),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10), // Increased padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0), // More transparent
          borderRadius: BorderRadius.circular(20), // Rounded corners
          border: Border.all(
            color: textCDark, // Border color
            width: 5, // Border width
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded image corners
              child: widget.link.isNotEmpty
                  ? Image.network(
                      widget.link,
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
                widget.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            isBookmarked()
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.bookmark,
                      color: textC,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

Route _ReaderRoute(
  String title,
  String data,
) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ReaderPage(
      title: title,
      data: data,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.ease)),
        child: child,
      );
    },
  );
}

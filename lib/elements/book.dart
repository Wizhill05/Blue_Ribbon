import 'package:blue_ribbon/reusable.dart';
import 'package:blue_ribbon/screens/reader.dart';
import 'package:flutter/material.dart';

Widget Book(BuildContext context, String imageUrl, String title, String data,
    {int progress = 0}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        _ReaderRoute(title, data, progress),
      ).then((_) {});
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10), // Increased padding
      decoration: BoxDecoration(
        color: Colors.transparent, // More transparent
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Optional: Display progress indicator as a bookmark
          if (progress > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.bookmark,
                color: textCDark,
              ),
            ),
        ],
      ),
    ),
  );
}

Route _ReaderRoute(String title, String data, int progress) {
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

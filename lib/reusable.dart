import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:blue_ribbon/screens/reader.dart';

import 'main.dart';

toColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "ff$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}

Color bgC = toColor("caf0f8");
Color textC = toColor("012A4A");
Color textCDark = toColor("00111f");

Image logoWidget(String imageName, double x, double y) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: x,
    height: y,
  );
}

Widget Book(BuildContext context, String link, String title, String data,
    {int progress = 0}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        _ReaderRoute(title, data, progress),
      );
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20), // Increased padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0), // More transparent
        borderRadius: BorderRadius.circular(15), // Rounded corners
        border: Border.all(
          color: textC, // Border color
          width: 5, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Rounded image corners
            child: link.isNotEmpty
                ? Image.network(
                    link,
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
          // Optional: Display progress indicator
          if (progress > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.bookmark,
                color: textC,
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

Future<List<Map<String, String>>> fetchWordDefinition(String word) async {
  word = removeSpecialCharacters(word);
  final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';

  List<Map<String, String>> wordDetails = [];

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response

      List<dynamic> wordDefinition = jsonDecode(response.body);

      // Extract details from the response

      String word = wordDefinition[0]['word'];

      // Extract phonetics

      List<dynamic> phoneticsList = wordDefinition[0]['phonetics'];

      String phoneticTranscription =
          phoneticsList.isNotEmpty ? phoneticsList[0]['text'] ?? '' : '';

      // Extract audio links

      List<String> audioLinks = phoneticsList
          .map((phonetic) => phonetic['audio'] as String)
          .where((audio) => audio.isNotEmpty)
          .toList();

      // Store the results
      if (kDebugMode) {
        print(phoneticTranscription);
      }

      wordDetails.add({
        'definition': await askGemini(
                "help a dyslexic person understand the meaning of this word, the words should be vey simple, answer in 1 line: $wordDefinition") ??
            "",

        'phonetic': await askGemini(
                "help a dyslexic person pronounce this word, answer in one word: $word") ??
            "",

        'audio': audioLinks.isNotEmpty
            ? audioLinks[0]
            : '', // You can choose to return all audio links if needed
      });

      return wordDetails; // Return the list of details
    } else {
      throw Exception('Failed to load definition');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }

    return []; // Return an empty list on error
  }
}

String removeSpecialCharacters(String input) {
  final RegExp alphanumericRegex = RegExp(r'[^a-zA-Z0-9]');
  return input.replaceAll(alphanumericRegex, '');
}

Future<void> playAudio(String url) async {
  final player = AudioPlayer();
  player.setReleaseMode(ReleaseMode.stop);

  // Start the player as soon as the app is displayed.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await player.setSource(UrlSource(url));
    await player.resume();
  });
}

Widget reusableTextField(String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: toColor("#020800"),
    cursorWidth: 2,
    cursorHeight: 20,
    style: TextStyle(
        color: toColor("#020800"), fontSize: 24, fontWeight: FontWeight.w900),
    maxLines: null,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(
          color: toColor("#020800").withAlpha(160),
          fontWeight: FontWeight.bold,
          fontSize: 20),
      filled: false,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: toColor("#020f00"), width: 2), // Dark green color
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: toColor("#072000"), width: 2), // Dark green color
      ),
    ),
    keyboardType:
        TextInputType.multiline, // Change to multiline for non-password fields
  );
}

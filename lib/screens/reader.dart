import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../reusable.dart';

class Reader extends StatefulWidget {
  final String title;
  final String data;

  const Reader({super.key, required this.title, required this.data});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  late List<String> words;
  int currentIndex = 0;
  double _sliderValue = 20;
  static const int wordsPerPage = 20;
  String _word = "";
  String _definition = "";
  String _audio = "";
  String _transcription = "";

  @override
  void initState() {
    super.initState();
    // Split the string into words
    _sliderValue = 20;
    words = widget.data.split(' ');
    _audio = "";
    _definition = "";
    _transcription = "Click a Word For its Pronunciation";
    _word = "Click";
  }

  void nextPage() {
    setState(() {
      if (currentIndex + wordsPerPage < words.length) {
        currentIndex += wordsPerPage;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentIndex - wordsPerPage >= 0) {
        currentIndex -= wordsPerPage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the words to display based on the current index
    List<String> displayedWords =
        words.skip(currentIndex).take(wordsPerPage).toList();

    return Scaffold(
      backgroundColor: bgC,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        iconTheme: const IconThemeData(
          size: 30,
        ),
        toolbarHeight: 100,
        backgroundColor: bgC,
      ),
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height - 320,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: StoryContainer(
                    words: displayedWords,
                    onWordTap: (word) async {
                      List<Map<String, String>> wordDetails =
                          await fetchWordDefinition(word);

                      if (wordDetails.isNotEmpty) {
                        setState(() {
                          _word = word;
                          _definition = wordDetails[0]['definition']!;
                          _transcription =
                              wordDetails[0]['phonetic']!.toLowerCase();
                          _audio = wordDetails[0]['audio']!;
                        });
                      } else {
                        if (kDebugMode) {
                          print('No details found.');
                        }
                      }
                    },
                    textSize: _sliderValue,
                  ),
                ),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF333A3F), width: 5),
                          color: bgC, // Replace with your bgC variable
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    removeSpecialCharacters(_word),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: textC),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    _transcription,
                                    style: GoogleFonts.notoSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: textC),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    _definition,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: textC),
                                  )),
                            ),
                          ],
                        )),
                  ),
                  Align(
                    alignment: const Alignment(1, 0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 40, 0),
                      child: IconButton(
                          onPressed: () {
                            playAudio(_audio);
                          },
                          icon: Icon(
                            Icons.volume_up_rounded,
                            color: textC,
                            size: 30,
                          )),
                    ),
                  )
                ])
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
          child: Align(
            alignment: const Alignment(-1, 1),
            child: GestureDetector(
              onTap: previousPage,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: toColor("333A3F"), width: 5),
                    color: toColor("56C0A1"),
                    borderRadius: BorderRadius.circular(1000)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
          child: Align(
            alignment: const Alignment(1, 1),
            child: GestureDetector(
              onTap:
                  currentIndex + wordsPerPage < words.length ? nextPage : null,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: toColor("333A3F"), width: 5),
                    color: toColor("56C0A1"),
                    borderRadius: BorderRadius.circular(1000)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
          child: Align(
            alignment: const Alignment(0, 1),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: toColor("333A3F"), width: 5),
                  color: toColor("56C0A1"),
                  borderRadius: BorderRadius.circular(1000)),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${((currentIndex - 1) / 20).ceil() + 1}",
                    style: const TextStyle(fontSize: 28),
                  )),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 1),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: toColor("333A3F"), width: 5),
                  color: toColor("56C0A1"),
                  borderRadius: BorderRadius.circular(1000)),
              height: 70,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Slider(
                  activeColor: textC,
                  value: _sliderValue,
                  min: 15,
                  max: 30,
                  divisions: 15,
                  label: _sliderValue.round().toString(),
                  onChanged: (double newValue) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _sliderValue = newValue;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class StoryContainer extends StatelessWidget {
  final List<String> words;
  final ValueChanged<String> onWordTap;
  final double textSize; // Add this line

  const StoryContainer(
      {super.key,
      required this.words,
      required this.onWordTap,
      required this.textSize}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF333A3F), width: 5),
        color: bgC, // Replace with your bgC variable
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0, // Space between words
          children: words.map((word) {
            return GestureDetector(
              onTap: () => onWordTap(word),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: toColor("000000")
                        .withAlpha(30), // Replace with your bgC variable
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Text(
                      word,
                      style: TextStyle(fontSize: textSize), // Use textSize here
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

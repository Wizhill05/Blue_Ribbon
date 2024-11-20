import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:hive/hive.dart';
import '../reusable.dart';

class ReaderPage extends StatefulWidget {
  final String title;
  final String data;
  final int initialProgress;

  const ReaderPage({
    super.key,
    required this.title,
    required this.data,
    this.initialProgress = 0,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late List<String> words;
  int currentIndex = 0;
  double _sliderValue = 20;
  static const int wordsPerPage = 20;
  String _word = "";
  String _definition = "";
  String _audio = "";
  String _transcription = "";
  bool _isLoading = false;
  late Box<int> _bookProgressBox; // Hive box for storing book progress
  final TextEditingController _textEditingController =
      TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    _bookProgressBox = Hive.box<int>('bookProgress'); // Initialize Hive box
    _sliderValue = 20;
    words = widget.data.split(' ');
    _audio = "";
    _definition = "";
    _transcription = "Click a Word For its Pronunciation";
    _word = "Click";

    // Set currentIndex from initialProgress
    currentIndex = widget.initialProgress;
  }

  void nextPage() {
    setState(() {
      if (currentIndex + wordsPerPage < words.length) {
        currentIndex += wordsPerPage;
        _saveProgress(); // Save progress when user navigates
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentIndex - wordsPerPage >= 0) {
        currentIndex -= wordsPerPage;
        _saveProgress(); // Save progress when user navigates
      }
    });
  }

  void _saveProgress() {
    // Save the current index to Hive using the book title as the key
    _bookProgressBox.put(widget.title, currentIndex);
  }

  @override
  void dispose() {
    _saveProgress(); // Save progress when the page is disposed
    super.dispose();
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
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 30, color: textCDark),
        ),
        iconTheme: const IconThemeData(
          size: 30,
        ),
        toolbarHeight: 100,
        backgroundColor: bgC,
      ),
      body: Stack(children: [
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
        SizedBox(
          height: MediaQuery.sizeOf(context).height - 120,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: StoryContainer(
                    words: displayedWords,
                    onWordTap: (word) async {
                      setState(() {
                        _isLoading = true; // Set loading state to true
                      });

                      List<Map<String, String>> wordDetails =
                          await fetchWordDefinition(word);

                      // Simulate a delay for loading (for demonstration purposes)
                      await Future.delayed(const Duration(seconds: 1));

                      setState(() {
                        _isLoading = false; // Set loading state to false
                      });

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

                // Display loading indicator if _isLoading is true

                if (_isLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child:
                          Lottie.asset("assets/LoaderSmall.json", height: 60),
                    ),
                  ),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: textCDark, width: 5),
                          color: bgC.withOpacity(
                              0.5), // Replace with your bgC variable
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
                                        color: textCDark),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    _transcription,
                                    style: TextStyle(
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
                ]),
                const SizedBox(
                  height: 260,
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 1),
          child: Container(
            height: 240,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              toColor("53c2a1").withOpacity(0.0),
              toColor("53c2a1")
            ], stops: const [
              0,
              0.5
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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
                    border: Border.all(color: textCDark, width: 5),
                    color: bgC.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1000)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back_rounded,
                      size: 40, color: textCDark),
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
                    border: Border.all(color: textCDark, width: 5),
                    color: bgC.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1000)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 40,
                    color: textCDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Choose Page Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textCDark,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    backgroundColor: toColor("bef3ed").withOpacity(0.9),
                    content: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 5, color: textCDark),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 3, color: textC),
                          ),
                        ),
                        cursorColor: textC,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: textC,
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            String val = _textEditingController.text;
                            int intVal;
                            try {
                              intVal = int.parse(val);
                              intVal = (intVal - 1) * wordsPerPage;
                              setState(() {
                                if ((intVal < words.length) || (intVal >= 0)) {
                                  currentIndex = intVal;
                                  _saveProgress(); // Save progress when user navigates
                                }
                              });
                            } catch (e) {
                              print(e.toString());
                            }
                            _textEditingController.text = "";
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(textCDark),
                          ),
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: MediaQuery.sizeOf(context).width,
                              child: Text(
                                "Go to Page",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: bgC, fontSize: 20),
                              )))
                    ],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
            child: Align(
              alignment: const Alignment(0, 1),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: textCDark, width: 5),
                    color: bgC.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1000)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${((currentIndex) / wordsPerPage).ceil() + 1}",
                      style: TextStyle(fontSize: 28, color: textCDark),
                    )),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 1),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: textCDark, width: 5),
                  color: bgC.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20)),
              height: 70,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Slider(
                  activeColor: textCDark,
                  inactiveColor: textC,
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

  const StoryContainer({
    super.key,
    required this.words,
    required this.onWordTap,
    required this.textSize,
  }); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: textCDark, width: 5),
        color: bgC.withOpacity(0.5), // Replace with your bgC variable
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
                      style: TextStyle(
                          fontSize: textSize,
                          color: textCDark,
                          fontWeight: FontWeight.w500), // Use textSize here
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

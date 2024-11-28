import 'package:blue_ribbon/screens/maid_llm.dart';
import 'package:blue_ribbon/screens/secret-page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maid_llm/maid_llm.dart';
import './reader.dart';
import '../main.dart';
import '../reusable.dart';

class Ask extends StatefulWidget {
  const Ask({super.key});

  @override
  State<Ask> createState() => _AskState();
}

class _AskState extends State<Ask> {
  final TextEditingController _text = TextEditingController(text: "");
  bool _incognitoMode = false;

  final List<ChatMessage> _messages = [];
  String? _model;

  void _loadModel() async {
    final result = await FilePicker.platform.pickFiles(
        dialogTitle: "Load Model File",
        type: FileType.any,
        allowMultiple: false,
        allowCompression: false
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _model = result.files.single.path!;
      });
    }
  }

  void _onSubmitted(String value) async {
    if (_model == null) {
      return;
    }

    setState(() {
      // _messages.add(ChatMessage(role: 'system', content: "Summarize this text in simple to read english:"));
      _messages.add(ChatMessage(role: 'user', content: value));
      _text.clear();
    });

    GptParams gptParams = GptParams(_model!);

    Stream<String> stream = MaidLLM(gptParams).prompt(_messages, "");

    setState(() {
      _messages.add(ChatMessage(role: 'assistant', content: ""));
    });

    stream.listen((message) {
      setState(() {
        final newContent = _messages.last.content + message;
        final newLastMessage = ChatMessage(role: 'assistant', content: newContent);
        _messages[_messages.length - 1] = newLastMessage;
      });
    });
    print("EXITED***************************************************");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReaderPage(
            title: "Summary",
            data: _messages[_messages.length].content
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgC,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: SizedBox(
          width: 300.0, // Set your desired width
          height: 72.0, // Set your desired height
          child: FloatingActionButton(
            isExtended: true,
            onPressed: () async {
              // Get the summarized text from Gemini
              if (!_incognitoMode) {
                String? summarizedText;

                summarizedText = await askServer(_text.text).then((_) {
                  return _;
                }, onError: (_) async {
                  String? temp = await askGemini(_text.text);
                  return temp;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReaderPage(
                      title: "Summary",
                      data: summarizedText ??
                          "Error in Request", // Handle null case
                    ),
                  ),
                );

                if (kDebugMode) {
                  print(summarizedText);
                }
              } else {
                _loadModel();
                _onSubmitted(_text.text);
              }

              // Navigate to Reader page with the summarized text
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
            backgroundColor: textCDark,
            child: Center(
              child: SizedBox(
                width: 300,
                height: 72,
                child: Stack(
                  children: [
                    Align(
                        alignment: const Alignment(-1, 0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                          child: Text(
                            "Summarize",
                            style: TextStyle(
                                color: toColor("d2ffcf"), fontSize: 20),
                          ),
                        )),
                    Align(
                      alignment: const Alignment(1, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 36, 0),
                        child: Icon(
                          color: toColor("d2ffcf"),
                          Icons.send_rounded,
                          size: 32, // Increase the icon size if needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                toColor("e3ffe4"),
                toColor("bfffc2"),
                toColor("96ff9a"),
              ],
              stops: const [
                0,
                0.5,
                1
              ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onDoubleTapCancel: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const link()));
                },
                child: Align(
                    alignment: const Alignment(0, -1),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 120,
                      child: Align(
                          alignment: const Alignment(-1, 1),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text(
                              "Ask",
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900,
                                  color: textCDark),
                            ),
                          )),
                    )),
              ),
              Divider(
                color: textCDark,
                thickness: 6,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: textCDark, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                    child: reusableTextField("Enter Text", _text),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaidLlmApp()
                      ),
                    );},
                    child: Text(
                      "Incognito Mode",
                      style: TextStyle(
                          color: textCDark, fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Checkbox(
                      activeColor: textCDark,
                      value: _incognitoMode,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _incognitoMode = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


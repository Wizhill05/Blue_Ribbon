import 'package:blue_ribbon/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import './reader.dart';
import '../main.dart';
import '../reusable.dart';

class link extends StatefulWidget {
  const link({super.key});

  @override
  State<link> createState() => _linkState();
}

class _linkState extends State<link> {
  TextEditingController _link = TextEditingController();
  late Box<String> _linkBox;
  late String linkAdd;
  @override
  void initState() {
    super.initState();
    _linkBox = Hive.box<String>('link');
    linkAdd = _linkBox.get("link") ?? Secrets().serverLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: SizedBox(
          width: 300.0, // Set your desired width
          height: 72.0, // Set your desired height
          child: FloatingActionButton(
            isExtended: true,
            onPressed: () async {
              String a = _link.text;
              if (a.isNotEmpty) {
                _linkBox.put("link", _link.text);
                setState(() {
                  linkAdd = a;
                });
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
            backgroundColor: toColor("#140000"),
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
                            "Update Link",
                            style: TextStyle(
                                color: toColor("#ffd1d1"), fontSize: 20),
                          ),
                        )),
                    Align(
                      alignment: const Alignment(1, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 36, 0),
                        child: Icon(
                          color: toColor("#ffd1d1"),
                          Icons.security,
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
      backgroundColor: bgC,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                toColor("ffeded"),
                toColor("ffa1a1"),
                toColor("a63c3c"),
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
                            "Dev",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w900,
                                color: textCDark),
                          ),
                        )),
                  )),
              Divider(
                color: textCDark,
                thickness: 6,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width - 110,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Current Link: $linkAdd",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: toColor("020f00")),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _linkBox.put("link", Secrets().serverLink());
                        setState(() {
                          linkAdd = Secrets().serverLink();
                        });
                      },
                      child: Container(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: toColor("140000"),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Icon(
                                    Icons.refresh,
                                    color: toColor("ffd1d1"),
                                    size: 30,
                                  ),
                                ))),
                      ),
                    ),
                  ],
                ),
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
                    child: TextField(
                      controller: _link,
                      cursorColor: toColor("#020800"),
                      cursorWidth: 4,
                      cursorHeight: 20,
                      style: TextStyle(
                          color: toColor("#020800"),
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Link",
                        labelStyle: TextStyle(
                            color: toColor("#020800").withAlpha(160),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        filled: false,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: toColor("#020f00"),
                              width: 4), // Dark green color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: toColor("#072000"),
                              width: 5), // Dark green color
                        ),
                      ),
                      keyboardType: TextInputType
                          .multiline, // Change to multiline for non-password fields
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}

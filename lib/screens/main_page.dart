import 'dart:async';

import 'package:blue_ribbon/screens/ask.dart';
import 'package:blue_ribbon/screens/news.dart';
import 'package:flutter/material.dart';
import '../reusable.dart';
import './library.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  Color _color1 = toColor("abe1ed");
  Color _color2 = toColor("79d4e8");

  double _stop = 0.2;

  @override
  void initState() {
    super.initState();

    _startColorAnimation();
  }

  void _startColorAnimation() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        // Swap colors for animation

        if (_color2 == toColor("79d4e8")) {
          _color1 = toColor("b8cdff");
          _color2 = toColor("#82a7ff");
          _stop = 0.2;
        } else {
          _color1 = toColor("abe1ed");
          _color2 = toColor("79d4e8");
          _stop = 0.4;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        curve: Curves.ease,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bgC,
                _color1,
                _color2,
              ],
              stops: [
                0,
                _stop,
                1
              ]),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.65),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                child: logoWidget(
                    "assets/Logo/brSemiT.png",
                    MediaQuery.sizeOf(context).width,
                    MediaQuery.sizeOf(context).width),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Align(
                  alignment: const Alignment(0, 0.4),
                  child: Text(
                    "blue ribbon",
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: textC),
                  )),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Align(
                    alignment: const Alignment(0, 0.4),
                    child: Text(
                      "reading for everyone",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: textC.withOpacity(0.7)),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
              child: Align(
                  alignment: const Alignment(-1, 1),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, _NewsRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: toColor("333A3F"), width: 5),
                            left:
                                BorderSide(color: toColor("333A3F"), width: 5),
                            right:
                                BorderSide(color: toColor("333A3F"), width: 2),
                            bottom:
                                BorderSide(color: toColor("333A3F"), width: 5),
                          ),
                          gradient: LinearGradient(colors: [
                            toColor("e4ff82"),
                            toColor("a3ff82"),
                          ], stops: const [
                            0.7,
                            1
                          ]),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      width: (MediaQuery.sizeOf(context).width - 60) / 3,
                      height: 80,
                      child: Icon(
                        Icons.newspaper_rounded,
                        color: textC,
                        size: 36,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Align(
                  alignment: const Alignment(0, 1),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, _AskRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: toColor("333A3F"), width: 5),
                          left: BorderSide(color: toColor("333A3F"), width: 3),
                          right: BorderSide(color: toColor("333A3F"), width: 3),
                          bottom:
                              BorderSide(color: toColor("333A3F"), width: 5),
                        ),
                        gradient: LinearGradient(colors: [
                          toColor("a3ff82"),
                          toColor("82ff86"),
                          toColor("82ff86"),
                          toColor("75f6a4"),
                        ], stops: const [
                          0,
                          0.3,
                          0.7,
                          1
                        ]),
                      ),
                      width: (MediaQuery.sizeOf(context).width - 60) / 3,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Icon(
                          Icons.question_answer_rounded,
                          color: textC,
                          size: 34,
                        ),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 30),
              child: Align(
                  alignment: const Alignment(1, 1),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, _LibraryRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: toColor("333A3F"), width: 5),
                            left:
                                BorderSide(color: toColor("333A3F"), width: 2),
                            right:
                                BorderSide(color: toColor("333A3F"), width: 5),
                            bottom:
                                BorderSide(color: toColor("333A3F"), width: 5),
                          ),
                          gradient: LinearGradient(colors: [
                            toColor("75f6a4"),
                            toColor("67ebc4"),
                          ], stops: const [
                            0,
                            0.3
                          ]),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      width: (MediaQuery.sizeOf(context).width - 60) / 3,
                      height: 80,
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: textC,
                        size: 36,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Route _LibraryRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Library(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.ease)),
          child: child,
        );
      },
    );
  }

  Route _AskRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Ask(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.ease)),
          child: child,
        );
      },
    );
  }

  Route _NewsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const NewsApiPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.ease)),
          child: child,
        );
      },
    );
  }
}

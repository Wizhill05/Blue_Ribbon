import 'package:blue_ribbon/screens/ask.dart';
import 'package:flutter/material.dart';
import '../reusable.dart';
import './library.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              toColor("79d4e8"),
              bgC,
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(70, 20, 70, 0),
                child: logoWidget(
                    "assets/Logo/brSemiT.png",
                    MediaQuery.sizeOf(context).width,
                    MediaQuery.sizeOf(context).width),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Align(
                  alignment: const Alignment(0, -0.05),
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
              child: Align(
                  alignment: const Alignment(0, 0.03),
                  child: Text(
                    "reading for everyone",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textC.withOpacity(0.7)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 40, 40),
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
                                BorderSide(color: toColor("333A3F"), width: 5),
                            right:
                                BorderSide(color: toColor("333A3F"), width: 5),
                            bottom:
                                BorderSide(color: toColor("333A3F"), width: 5),
                          ),
                          gradient: RadialGradient(colors: [
                            toColor("bdffeb"),
                            toColor("67ebc4"),
                          ], stops: const [
                            0,
                            0.9
                          ]),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      width: MediaQuery.sizeOf(context).width * 0.55 - 40,
                      height: MediaQuery.sizeOf(context).height / 3,
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: textC,
                        size: 72,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 40),
              child: Align(
                  alignment: const Alignment(-1, 1),
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
                            left:
                                BorderSide(color: toColor("333A3F"), width: 5),
                            right: BorderSide.none,
                            bottom:
                                BorderSide(color: toColor("333A3F"), width: 5),
                          ),
                          gradient: RadialGradient(
                            colors: [
                              toColor("ccffce"),
                              toColor("82ff86"),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                          )),
                      width: MediaQuery.sizeOf(context).width * 0.45 - 40,
                      height: MediaQuery.sizeOf(context).height / 6,
                      child: Icon(
                        Icons.question_answer_rounded,
                        color: textC,
                        size: 48,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  40, 0, 0, 40 + MediaQuery.sizeOf(context).height / 6),
              child: Align(
                  alignment: const Alignment(-1, 1),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Library()));
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
                            right: BorderSide.none,
                            bottom: BorderSide.none,
                          ),
                          gradient: RadialGradient(
                            colors: [
                              toColor("ffe9cf"),
                              toColor("ffc987"),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                          )),
                      width: MediaQuery.sizeOf(context).width * 0.45 - 40,
                      height: MediaQuery.sizeOf(context).height / 6,
                      child: Icon(
                        Icons.newspaper_rounded,
                        color: textC,
                        size: 48,
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
      pageBuilder: (context, animation, secondaryAnimation) => const Library(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.ease)),
          child: child,
        );
      },
    );
  }
}

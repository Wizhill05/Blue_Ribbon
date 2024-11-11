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
      backgroundColor: bgC,
      body: Stack(
        children: [
          // Align(
          //     alignment: const Alignment(0, -0.6),
          //     child: logoWidget("", 300, 300)),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Align(
                alignment: const Alignment(0, -0.05),
                child: Text(
                  "LyBry",
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w900, color: textC),
                )),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Align(
                alignment: const Alignment(0, 0.05),
                child: Text(
                  "Reading For Everyone",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500, color: textC),
                )),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Library()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: toColor("333A3F"), width: 5),
                      color: toColor("56C0A1"),
                      borderRadius: BorderRadius.circular(1000)),
                  width: 200,
                  height: 200,
                )),
          )
        ],
      ),
    );
  }
}

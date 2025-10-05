import 'package:flutter/material.dart';

class TitleOfApp extends StatelessWidget {
  const TitleOfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'T',
                style: TextStyle(
                  fontFamily: 'Silom',
                  color: Color(0xff9a3a51),
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              Text(
                'ot ',
                style: TextStyle(
                  fontFamily: 'Silom',
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
              Text(
                'T',
                style: TextStyle(
                  fontFamily: 'Silom',
                  color: Color(0xff9a3a51),
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              Text(
                'racker',
                style: TextStyle(
                  fontFamily: 'Silom',
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ],
          );
  }
}
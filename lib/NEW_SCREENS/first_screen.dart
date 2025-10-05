import 'package:flutter/material.dart';
import 'package:tottracker/NEW_SCREENS/main_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';
class FirstScreen extends StatefulWidget {
   const FirstScreen({super.key});
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _showIcon = true;
  bool _showPicture = true;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
     _isMounted = true;
    // Set the duration for which the icon should be displayed
    Future.delayed(Duration(seconds: 5), () {
      // After 3 seconds, hide the icon and navigate to the new page
      if (_isMounted) {
      setState(() {
        _showIcon = false;
        _showPicture = false;
      });
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);}
    });
  }
  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 224, 224),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: _showPicture ? 1.0 : 0.0,
                child: Container(
                    width: 500, // set the desired width
                    height: 500,
                    child: Image.asset('assets/drawables/tottracker.png')),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _showIcon
                    ? Text('',
                        key: UniqueKey(),
                        style: TextStyle(
                          fontFamily: 'Silom',
                        ))
                    : Text(
                        'Loading...',
                        key: UniqueKey(),
                      ),
              ),
              
              _showIcon
                  ?  LoadingIndicator(indicatorType:Indicator.lineScaleParty,colors: const [Color(0xff1c69a2),Color(0xff9a3a51)],  )
                  : Container(),
              SizedBox(height: 50),
            ],
          ),
        ),
      )
    );
  }
}

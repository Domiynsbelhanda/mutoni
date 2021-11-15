import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mutoni/global.dart';
import 'package:mutoni/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutoni',
      debugShowCheckedModeBanner: false,
      color: couleurPrimaire,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Timer _timer;

  bool next = true;

  buttonNext() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        next = !next;
      });

    });
  }

  @override
  void initState() {
    super.initState();
    buttonNext();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 73.0,
              width: 189,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/Mutoni.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            
            SizedBox(height: 8.0),

            Text(
              'Les rivieres de lubumbashi',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: const Color(0xff08375d),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),

            SizedBox(height: 8.0),

            // Adobe XD layer: 'carte1' (shape)
            Container(
              width: 250,
              height: 277,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/lushi.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 16.0),
 
            AnimatedOpacity(
              opacity: next ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 1000),
              child: button(context, 'Suivant', (){
                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context){
                                    return Home();
                                  })
                              );
              })
            )
          ],
        ),
      ),
    );
  }
}

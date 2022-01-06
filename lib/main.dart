import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wigi/views/home_view.dart';
import 'package:wigi/views/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,690),
      builder: () { return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(appBarTheme: AppBarTheme(backgroundColor: Colors.black.withOpacity(0))),
        home: const SplashScreen(),
      ); },

    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: _controller!,curve: Curves.fastOutSlowIn);
    _controller!.forward();
    _controller!.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        _controller!.dispose();
        _checkIfLoggedIn();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  void _checkIfLoggedIn() async{
    const localStorage =  FlutterSecureStorage();
    String? token = await localStorage.read(key: 'user');
    if(token != null){
      Navigator.pushAndRemoveUntil(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),pageBuilder: (context, animation, secondaryAnimation) => const Home(),), (route) => false);

    }else{
      Navigator.pushAndRemoveUntil(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),pageBuilder: (context, animation, secondaryAnimation) => const Login(),), (route) => false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: ScaleTransition(scale: animation!,child: Hero(tag: 'logo',child: Image.asset('assets/wigi.png'))),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

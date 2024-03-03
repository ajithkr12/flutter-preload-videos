
import 'package:flutter/material.dart';
import 'package:flutter_preload_videos/injection.dart';
import 'package:flutter_preload_videos/video_main.dart';
import 'package:injectable/injectable.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Environment.prod);

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoMain(),
    );
  }
}

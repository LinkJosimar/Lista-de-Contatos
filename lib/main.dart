import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'homepage.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const HomePage());
}

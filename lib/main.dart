import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spartapp_ayala_lucas/injection_container.dart';
import 'package:spartapp_ayala_lucas/src/app.dart';

void main() async {
  setupInjection();

  await dotenv.load(fileName: ".env");

  runApp(const ImgurApp());
}

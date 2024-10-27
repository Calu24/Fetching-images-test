import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spartapp_ayala_lucas/src/app.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  
  runApp(const ShareApp());
}

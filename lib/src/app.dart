import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/pages/home_page.dart';

class ImgurApp extends StatelessWidget {
  const ImgurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImgurCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Test - Spartapp Ayala Lucas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[300]!),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

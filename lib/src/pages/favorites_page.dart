import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/widgets/background_app_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/image_slider_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 23, 42),
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          const BackgroundApp(),
          Center(
            child: ImageSlider(
              imagesLink: context
                  .read<ImgurCubit>()
                  .state
                  .favoriteImages
                  .map((e) => e.imageUrl)
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

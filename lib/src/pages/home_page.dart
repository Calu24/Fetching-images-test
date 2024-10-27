import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/widgets/image_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImgurCubit()..getPopularImages(),
      child: BlocBuilder<ImgurCubit, ImgurState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 1, 23, 42),
            title: const Text(
              'Imgur App',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 10,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.green,
                ),
                onPressed: () => {},
                // onPressed: () => showSearch(
                //     context: context, delegate: MovieSearchDelegate()),
              )
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 1, 23, 42),
                      Color.fromARGB(255, 96, 95, 95),
                    ],
                  ),
                ),
              ),
              Center(
                child: CarouselSlider.builder(
                  itemCount: state.imagesLink.length,
                  itemBuilder: (BuildContext context, int itemIndex, int i) =>
                      ImageCard(imageLink: state.imagesLink[itemIndex]),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    scrollDirection: Axis.vertical,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Popular Images',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

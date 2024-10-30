import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/injection_container.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/pages/favorites_page.dart';
import 'package:spartapp_ayala_lucas/src/search/search_delegate.dart';
import 'package:spartapp_ayala_lucas/src/widgets/background_app_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/image_slider_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/shimmer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ImgurCubit>()..getPopularImages(),
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
                onPressed: () => showSearch(
                    context: context, delegate: ImageSearchDelegate()),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoritesPage(),
              ),
            ),
            child: const Icon(
              Icons.list,
              color: Colors.black45,
              size: 40,
            ),
          ),
          body: Stack(
            children: [
              const BackgroundApp(),
              Center(
                child: state.isLoading && state.isFirstPage
                    ? const ShimmerWidget()
                    : ImageSlider(
                        imagesLink: state.imagesLinks,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Popular Images',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

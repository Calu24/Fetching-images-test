import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';
import 'package:spartapp_ayala_lucas/src/widgets/background_app_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/image_card_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/shimmer_widget.dart';

class ImageSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search for a image';

  @override
  TextStyle get searchFieldStyle =>
      const TextStyle(color: Colors.white, fontSize: 18);

  final ScrollController _scrollController = ScrollController();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.green,
        ),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 1, 23, 42),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.green),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final cubit = context.read<ImgurCubit>();
    return BlocBuilder<ImgurCubit, ImgurState>(
      builder: (context, state) {
        return Stack(
          children: [
            const BackgroundApp(),
            Center(
              child: ImageCard(
                imageLink: state.selectedImage!.imageUrl,
              ),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: IconButton(
                  key: ValueKey<bool>(state.selectedImage!.isFavorite),
                  icon: Icon(
                    state.selectedImage!.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: state.selectedImage!.isFavorite
                        ? Colors.red
                        : Colors.white38,
                    size: 50,
                  ),
                  onPressed: () {
                    cubit.toggleFavorite(state.selectedImage!);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _emptyContainer() {
    return const Stack(
      children: [
        BackgroundApp(),
        Center(
          child: Icon(
            Icons.image,
            color: Colors.white38,
            size: ShimmerWidget.size,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    context.read<ImgurCubit>().getSuggestionsByQuery(query);

    return Stack(
      children: [
        const BackgroundApp(),
        StreamBuilder(
          stream: context.read<ImgurCubit>().suggestionStream,
          builder: (_, AsyncSnapshot<List<GalleryModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: ShimmerWidget(),
              );
            }

            if (!snapshot.hasData) return _emptyContainer();

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  context.read<ImgurCubit>().loadMoreImages();
                }
                return true;
              },
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final gallery = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gallery.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 60,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...gallery.images.map((image) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: OutlinedButton(
                                          child: Icon(
                                            image.link.endsWith('.mp4')
                                                ? Icons
                                                    .videocam
                                                : Icons.image,
                                            color: Colors.white38,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<ImgurCubit>()
                                                .updateSelectedImage(
                                                    image.link);
                                            showResults(context);
                                          },
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.black.withOpacity(0.8),
                      ),
                      onPressed: () {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Icon(Icons.arrow_upward),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

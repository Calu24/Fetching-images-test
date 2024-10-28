import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/widgets/background_app_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/image_slider_widget.dart';
import 'package:spartapp_ayala_lucas/src/widgets/shimmer_widget.dart';

class ImageSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search for a image';

  @override
  TextStyle get searchFieldStyle =>
      const TextStyle(color: Colors.white, fontSize: 18);

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
    return const Text('buildResults');
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
          builder: (_, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: ShimmerWidget(),
              );
            }

            if (!snapshot.hasData) return _emptyContainer();

            final imagesLink = snapshot.data!;

            return ImageSlider(imagesLink: imagesLink);
          },
        ),
      ],
    );
  }
}

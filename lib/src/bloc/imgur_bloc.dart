import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:spartapp_ayala_lucas/src/helpers/debouncer.dart';
import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';

part 'imgur_state.dart';

class ImgurCubit extends Cubit<ImgurState> {
  ImgurCubit() : super(const ImgurState());

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  final StreamController<List<String>> _suggestionStreamContoller =
      StreamController.broadcast();
  Stream<List<String>> get suggestionStream =>
      _suggestionStreamContoller.stream;

  Future<void> getPopularImages() async {
    final url = Uri.https('api.imgur.com', '3/gallery/hot/viral/week/1');
    final clientId = dotenv.env['client-id'];
    final headers = {
      'Authorization': 'Client-ID $clientId',
    };
    final response = await http.get(url, headers: headers);
    final jsonData = response.body;
    final galleries = GalleryResponse.fromJson(jsonData);

    List<String> imagesLink = [];

    for (var gallery in galleries.data) {
      for (var images in gallery.images) {
        imagesLink.add(images.link);
      }
    }

    return emit(state.copyWith(imagesLink: imagesLink));
  }

  Future<List<String>> searchImage(String query) async {
    emit(state.copyWith(isLoading: true));

    final url = Uri.https(
        'api.imgur.com', '3/gallery/search/viral/all/1', {'q': query});
    final clientId = dotenv.env['client-id'];
    final headers = {
      'Authorization': 'Client-ID $clientId',
    };
    final response = await http.get(url, headers: headers);
    final jsonData = response.body;
    final galleries = GalleryResponse.fromJson(jsonData);

    List<String> imagesLink = [];

    for (var gallery in galleries.data) {
      for (var images in gallery.images) {
        imagesLink.add(images.link);
      }
    }

    emit(state.copyWith(isLoading: false));
    return imagesLink;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchImage(value);
      _suggestionStreamContoller.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}

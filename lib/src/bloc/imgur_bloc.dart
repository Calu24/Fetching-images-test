import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:spartapp_ayala_lucas/src/helpers/debouncer.dart';
import 'package:spartapp_ayala_lucas/src/models/favorite_image_model.dart';
import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';

part 'imgur_state.dart';

class ImgurCubit extends Cubit<ImgurState> {
  ImgurCubit() : super(const ImgurState());

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  final StreamController<List<GalleryModel>> _suggestionStreamContoller =
      StreamController.broadcast();
  Stream<List<GalleryModel>> get suggestionStream =>
      _suggestionStreamContoller.stream;

  void getPopularImages() async {
    emit(state.copyWith(isLoading: true));

    final url = Uri.https('api.imgur.com', '3/gallery/hot/viral/week/1');
    //final clientId = dotenv.env['client-id'];
    final clientId = 090e58d5dba0f9c;
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

    return emit(
      state.copyWith(imagesLinks: imagesLink, isLoading: false),
    );
  }

  Future<List<GalleryModel>> searchImage(String query) async {
    final url = Uri.https('api.imgur.com',
        '3/gallery/search/viral/all/${state.searchPageNumber}', {'q': query});
    final clientId = dotenv.env['client-id'];
    final headers = {
      'Authorization': 'Client-ID $clientId',
    };
    final response = await http.get(url, headers: headers);
    final jsonData = response.body;
    final galleries = GalleryResponse.fromJson(jsonData);

    emit(state.copyWith(galleryModels: galleries.data));
    return galleries.data;
  }

  Future<void> loadMoreImages() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    final url = Uri.https('api.imgur.com',
        '3/gallery/hot/viral/all/${state.searchPageNumber + 1}');
    final clientId = dotenv.env['client-id'];
    final headers = {
      'Authorization': 'Client-ID $clientId',
    };
    final response = await http.get(url, headers: headers);
    final jsonData = response.body;
    final galleries = GalleryResponse.fromJson(jsonData);

    final galleriesTotal = [...state.galleryModels, ...galleries.data];

    _suggestionStreamContoller.add(galleriesTotal);
    emit(
      state.copyWith(
          isLoading: false, searchPageNumber: state.searchPageNumber + 1),
    );
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

  void updateSelectedImage(String imageUrl) {
    final favoritesImages = List<FavoriteImageModel>.from(state.favoriteImages);

    final isFavorite =
        favoritesImages.any((image) => image.imageUrl == imageUrl);

    emit(state.copyWith(
      selectedImage:
          FavoriteImageModel(imageUrl: imageUrl, isFavorite: isFavorite),
    ));
  }

  void toggleFavorite(FavoriteImageModel favImage) {
    final favoriteImages = List<FavoriteImageModel>.from(state.favoriteImages);

    final isAlreadyFavorite = favoriteImages.any((image) => image.imageUrl == favImage.imageUrl);

    List<FavoriteImageModel> updatedFavorites;
    if (isAlreadyFavorite) {
      updatedFavorites = favoriteImages.map((favoriteImage) {
      if (favoriteImage.imageUrl == favImage.imageUrl) {
        return favoriteImage.copyWith(isFavorite: !favoriteImage.isFavorite);
      }
      return favoriteImage;
      }).toList();
    } else {
      updatedFavorites = [...favoriteImages, favImage.copyWith(isFavorite: true)];
    }

    emit(state.copyWith(
      favoriteImages: updatedFavorites,
      selectedImage: favImage.copyWith(isFavorite: !favImage.isFavorite),
    ));
  }
}

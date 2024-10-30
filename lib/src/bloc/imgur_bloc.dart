import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spartapp_ayala_lucas/src/helpers/debouncer.dart';
import 'package:spartapp_ayala_lucas/src/models/favorite_image_model.dart';
import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';
import 'package:spartapp_ayala_lucas/src/respositories/imgur_repository.dart';

part 'imgur_state.dart';

class ImgurCubit extends Cubit<ImgurState> {
  final ImgurRepository imgurRepository;

  ImgurCubit(this.imgurRepository) : super(const ImgurState());

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  final StreamController<List<GalleryModel>> _suggestionStreamContoller =
      StreamController.broadcast();
  Stream<List<GalleryModel>> get suggestionStream =>
      _suggestionStreamContoller.stream;

  void getPopularImages() async {
    try {
      emit(state.copyWith(isLoading: true));

      final galleries = await imgurRepository.fetchPopularImages();
      List<String> imagesLink = [];

      if (galleries == null) return emit(state.copyWith(isLoading: false));

      for (var gallery in galleries) {
        for (var images in gallery.images) {
          imagesLink.add(images.link);
        }
      }

      return emit(
        state.copyWith(imagesLinks: imagesLink, isLoading: false),
      );
    } catch (e) {
      // print(e);
      return emit(state.copyWith(isLoading: false));
    }
  }

  Future<List<GalleryModel>> searchImage(String query) async {
    try {
      final galleries = await imgurRepository.searchImages(query);

      if (galleries == null) {
        emit(state.copyWith(galleryModels: [], query: query));
        return [];
      }

      emit(state.copyWith(galleryModels: galleries, query: query));
      return galleries;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<void> loadMoreImages() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final galleries = await imgurRepository.loadMoreImages(
          state.query, state.searchPageNumber + 1);

      if (galleries == null) return emit(state.copyWith(isLoading: false));

      final galleriesTotal = [...state.galleryModels, ...galleries];

      _suggestionStreamContoller.add(galleriesTotal);
      return emit(
        state.copyWith(
            isLoading: false, searchPageNumber: state.searchPageNumber + 1),
      );
    } catch (e) {
      // print(e);
      return emit(state.copyWith(isLoading: false));
    }
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

    final isAlreadyFavorite =
        favoriteImages.any((image) => image.imageUrl == favImage.imageUrl);

    List<FavoriteImageModel> updatedFavorites;
    if (isAlreadyFavorite) {
      updatedFavorites = favoriteImages.map((favoriteImage) {
        if (favoriteImage.imageUrl == favImage.imageUrl) {
          return favoriteImage.copyWith(isFavorite: !favoriteImage.isFavorite);
        }
        return favoriteImage;
      }).toList();
    } else {
      updatedFavorites = [
        ...favoriteImages,
        favImage.copyWith(isFavorite: true)
      ];
    }

    emit(state.copyWith(
      favoriteImages: updatedFavorites,
      selectedImage: favImage.copyWith(isFavorite: !favImage.isFavorite),
    ));
  }
}

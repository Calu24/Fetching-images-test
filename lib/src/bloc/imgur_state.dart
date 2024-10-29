part of 'imgur_bloc.dart';

class ImgurState extends Equatable {
  const ImgurState({
    this.isLoading = false,
    this.imagesLinks = const [],
    this.searchPageNumber = 1,
    this.galleryModels = const [],
    this.selectedImage,
    this.favoriteImages = const [],
  });

  final bool isLoading;
  final List<String> imagesLinks;
  final int searchPageNumber;
  final List<GalleryModel> galleryModels;
  final FavoriteImageModel? selectedImage;
  final List<FavoriteImageModel> favoriteImages;

  bool get isFirstPage => searchPageNumber == 1;

  ImgurState copyWith({
    bool? isLoading,
    List<String>? imagesLinks,
    int? searchPageNumber,
    List<GalleryModel>? galleryModels,
    FavoriteImageModel? selectedImage,
    List<FavoriteImageModel>? favoriteImages,
  }) =>
      ImgurState(
        isLoading: isLoading ?? this.isLoading,
        imagesLinks: imagesLinks ?? this.imagesLinks,
        searchPageNumber: searchPageNumber ?? this.searchPageNumber,
        galleryModels: galleryModels ?? this.galleryModels,
        selectedImage: selectedImage ?? this.selectedImage,
        favoriteImages: favoriteImages ?? this.favoriteImages,
      );

  @override
  List<Object?> get props => [
        isLoading,
        imagesLinks,
        searchPageNumber,
        galleryModels,
        selectedImage,
        favoriteImages,
      ];
}

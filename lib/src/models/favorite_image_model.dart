class FavoriteImageModel {
  String imageUrl;
  bool isFavorite;

  FavoriteImageModel({
    required this.imageUrl,
    required this.isFavorite,
  });

  FavoriteImageModel copyWith({
    String? imageUrl,
    bool? isFavorite,
  }) {
    return FavoriteImageModel(
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

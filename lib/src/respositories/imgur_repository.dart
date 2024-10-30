import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';

abstract class ImgurRepository {
  Future<List<GalleryModel>>? fetchPopularImages();
  Future<List<GalleryModel>>? searchImages(String query, {int page = 1});
  Future<List<GalleryModel>>? loadMoreImages(String query, int page);
}

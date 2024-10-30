// lib/src/repositories/imgur_repository_impl.dart
import 'package:http/http.dart' as http;
import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';
import 'package:spartapp_ayala_lucas/src/respositories/imgur_repository.dart';

class ImgurRepositoryImpl implements ImgurRepository {
  final String _baseUrl = 'https://api.imgur.com/3';
  final String _clientId = '090e58d5dba0f9c';

  @override
  Future<List<GalleryModel>> fetchPopularImages() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/gallery/hot/viral/week/1'),
      headers: {'Authorization': 'Client-ID $_clientId'},
    );

    if (response.statusCode == 200) {
      final jsonData = response.body;
      final galleries = GalleryResponse.fromJson(jsonData);
      return galleries.data;
    } else {
      throw Exception('Failed to load popular images');
    }
  }

  @override
  Future<List<GalleryModel>> searchImages(String query, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/gallery/search/viral/all/$page?q=$query'),
      headers: {'Authorization': 'Client-ID $_clientId'},
    );

    if (response.statusCode == 200) {
      final jsonData = response.body;
      final galleries = GalleryResponse.fromJson(jsonData);
      return galleries.data;
    } else {
      throw Exception('Failed to search images');
    }
  }

  @override
  Future<List<GalleryModel>> loadMoreImages(String query, int page) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/gallery/search/viral/all/$page?q=$query'),
      headers: {'Authorization': 'Client-ID $_clientId'},
    );

    if (response.statusCode == 200) {
      final jsonData = response.body;
      final galleries = GalleryResponse.fromJson(jsonData);
      return galleries.data;
    } else {
      throw Exception('Failed to load more');
    }
  }
}

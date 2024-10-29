import 'dart:convert';

class GalleryResponse {
  final List<GalleryModel> data;

  GalleryResponse({required this.data});

  factory GalleryResponse.fromJson(String str) =>
      GalleryResponse.fromMap(json.decode(str));

  factory GalleryResponse.fromMap(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<GalleryModel> data =
        dataList.map((i) => GalleryModel.fromJson(i)).toList();

    return GalleryResponse(data: data);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class GalleryModel {
  final String id;
  final String title;
  final List<ImageGallery> images;

  GalleryModel({required this.id, required this.title, required this.images});

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List? ?? [];
    List<ImageGallery> images =
        imagesList.map((i) => ImageGallery.fromJson(i)).toList();

    return GalleryModel(
      id: json['id'],
      title: json['title'],
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'images': images.map((v) => v.toJson()).toList(),
    };
  }
}

class ImageGallery {
  final String id;
  final String link;

  ImageGallery({required this.id, required this.link});

  factory ImageGallery.fromJson(Map<String, dynamic> json) {
    return ImageGallery(
      id: json['id'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
    };
  }
}

import 'dart:convert';

class GalleryResponse {
  final List<GalleryData> data;

  GalleryResponse({required this.data});

  factory GalleryResponse.fromJson(String str) =>
      GalleryResponse.fromMap(json.decode(str));

  factory GalleryResponse.fromMap(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<GalleryData> data =
        dataList.map((i) => GalleryData.fromJson(i)).toList();

    return GalleryResponse(data: data);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class GalleryData {
  final String id;
  final String title;
  final List<GalleryImage> images;

  GalleryData({required this.id, required this.title, required this.images});

  factory GalleryData.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List;
    List<GalleryImage> images =
        imagesList.map((i) => GalleryImage.fromJson(i)).toList();

    return GalleryData(
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

class GalleryImage {
  final String id;
  final String link;

  GalleryImage({required this.id, required this.link});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
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

class GalleryModel {
  final String id;
  final String title;
  final List<Image> images;

  GalleryModel({required this.id, required this.title, required this.images});

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List? ?? [];
    List<Image> images =
        imagesList.map((i) => Image.fromJson(i)).toList();

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

class Image {
  final String id;
  final String link;

  Image({required this.id, required this.link});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
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

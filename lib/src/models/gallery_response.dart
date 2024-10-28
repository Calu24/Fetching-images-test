import 'dart:convert';

import 'package:spartapp_ayala_lucas/src/models/gallery_model.dart';

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

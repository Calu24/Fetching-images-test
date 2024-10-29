import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spartapp_ayala_lucas/src/widgets/image_card_widget.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    super.key,
    required this.imagesLink,
  });

  final List<String> imagesLink;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imagesLink.length,
      itemBuilder: (BuildContext context, int itemIndex, int _) =>
          ImageCard(imageLink: imagesLink[itemIndex]),
      options: CarouselOptions(
        height: double.infinity,
        scrollDirection: Axis.vertical,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        animateToClosest: true,
      ),
    );
  }
}

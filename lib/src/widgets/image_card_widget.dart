import 'package:flutter/material.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({
    required this.imageLink,
    super.key,
  });
  final String imageLink;
  @override
  ImageCardState createState() => ImageCardState();
}

class ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.network(
        widget.imageLink,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          // print(error); //Invalid image data
          return const Center(
            child: Text(
              'Image failed to load',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}

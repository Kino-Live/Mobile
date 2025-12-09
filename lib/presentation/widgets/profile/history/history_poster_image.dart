import 'package:flutter/material.dart';

class HistoryPosterImage extends StatelessWidget {
  final String? posterUrl;

  const HistoryPosterImage({
    super.key,
    this.posterUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (posterUrl == null || posterUrl!.isEmpty) {
      return Image.asset(
        'assets/images/placeholder_poster.jpg',
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      posterUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/placeholder_poster.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}


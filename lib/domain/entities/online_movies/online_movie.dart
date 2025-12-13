class OnlineMovie {
  final int movieId;
  final double price;
  final String currency;

  const OnlineMovie({
    required this.movieId,
    required this.price,
    required this.currency,
  });
}

class OnlineMoviePurchase {
  final String orderId;
  final int movieId;
  final double price;
  final String currency;

  const OnlineMoviePurchase({
    required this.orderId,
    required this.movieId,
    required this.price,
    required this.currency,
  });
}

class OnlineMovieWatch {
  final int movieId;
  final String videoUrl;

  const OnlineMovieWatch({
    required this.movieId,
    required this.videoUrl,
  });
}

class MyOnlineMovie {
  final int movieId;
  final String title;
  final String posterUrl;
  final DateTime purchasedAt;
  final double price;
  final String currency;

  const MyOnlineMovie({
    required this.movieId,
    required this.title,
    required this.posterUrl,
    required this.purchasedAt,
    required this.price,
    required this.currency,
  });
}


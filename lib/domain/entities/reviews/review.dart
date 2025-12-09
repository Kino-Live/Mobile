class Review {
  final String id;
  final int movieId;
  final String userEmail;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? movieTitle;
  final String? posterUrl;

  const Review({
    required this.id,
    required this.movieId,
    required this.userEmail,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.movieTitle,
    this.posterUrl,
  });
}


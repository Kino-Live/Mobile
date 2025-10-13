class MovieDetails {
  final int id;
  final String title;
  final String originalTitle;
  final String posterUrl;
  final int year;
  final String ageRestrictions;
  final List<String> genres;
  final String language;
  final String duration;
  final String producer;
  final String director;
  final List<String> cast;
  final String description;
  final String trailerUrl;
  final double rating;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.posterUrl,
    required this.year,
    required this.ageRestrictions,
    required this.genres,
    required this.language,
    required this.duration,
    required this.producer,
    required this.director,
    required this.cast,
    required this.description,
    required this.trailerUrl,
    required this.rating,
  });
}

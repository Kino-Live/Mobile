class ShowTime {
  final String id;
  final int movieId;
  final String date;
  final String quality; // "2D" or "3D"
  final String startIso;
  final String endIso;
  final int hallId;

  const ShowTime({
    required this.id,
    required this.movieId,
    required this.date,
    required this.quality,
    required this.startIso,
    required this.endIso,
    required this.hallId,
  });
}

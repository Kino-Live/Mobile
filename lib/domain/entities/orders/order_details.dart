class OrderDetails {
  final String id;

  final String movieTitle;
  final String cinemaName;
  final String cinemaAddress;
  final String cinemaCity;

  final DateTime showStart;
  final List<String> seats;
  final int ticketsCount;

  const OrderDetails({
    required this.id,
    required this.movieTitle,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.cinemaCity,
    required this.showStart,
    required this.seats,
    required this.ticketsCount,
  });
}

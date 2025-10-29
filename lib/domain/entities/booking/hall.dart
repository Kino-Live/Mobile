class HallInfo {
  final ShowtimeMeta showtime;
  final CinemaMeta cinema;
  final HallLayout hall;

  const HallInfo({
    required this.showtime,
    required this.cinema,
    required this.hall,
  });
}

class ShowtimeMeta {
  final String id;
  final int movieId;
  final String date;
  final String quality;
  final String startIso;
  final String endIso;
  final int hallId;

  const ShowtimeMeta({
    required this.id,
    required this.movieId,
    required this.date,
    required this.quality,
    required this.startIso,
    required this.endIso,
    required this.hallId,
  });
}

class CinemaMeta {
  final int id;
  final String name;
  final String address;
  final String city;

  const CinemaMeta({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });
}

class HallLayout {
  final int id;
  final String name;
  final List<HallRow> rows;

  const HallLayout({
    required this.id,
    required this.name,
    required this.rows,
  });
}

class HallRow {
  final String rowName;
  final List<HallSeat> seats;

  const HallRow({
    required this.rowName,
    required this.seats,
  });
}

enum HallSeatStatus { available, reserved, blocked }

class HallSeat {
  final String code;
  final HallSeatStatus status;

  const HallSeat({
    required this.code,
    required this.status,
  });
}

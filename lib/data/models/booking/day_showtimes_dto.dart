import 'package:json_annotation/json_annotation.dart';
import 'showtime_slot_dto.dart';

part 'day_showtimes_dto.g.dart';

@JsonSerializable(createToJson: false)
class DayShowtimesDto {
  @JsonKey(name: '2D', fromJson: _slotsFromJson)
  final List<ShowtimeSlotDto> twoD;

  @JsonKey(name: '3D', fromJson: _slotsFromJson)
  final List<ShowtimeSlotDto> threeD;

  const DayShowtimesDto({
    required this.twoD,
    required this.threeD,
  });

  factory DayShowtimesDto.fromJson(Map<String, dynamic> json) =>
      _$DayShowtimesDtoFromJson(json);

  static List<ShowtimeSlotDto> _slotsFromJson(Object? raw) {
    final list = (raw as List?) ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(ShowtimeSlotDto.fromJson)
        .toList();
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'showtime_slot_dto.dart';

part 'day_showtimes_dto.g.dart';

@JsonSerializable(createToJson: false)
class DayShowtimesDto {
  @JsonKey(name: '2D')
  final List<ShowtimeSlotDto> twoD;

  @JsonKey(name: '3D')
  final List<ShowtimeSlotDto> threeD;

  const DayShowtimesDto({
    required this.twoD,
    required this.threeD,
  });

  factory DayShowtimesDto.fromJson(Map<String, dynamic> json) =>
      _$DayShowtimesDtoFromJson(json);
}

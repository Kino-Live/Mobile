import 'package:json_annotation/json_annotation.dart';

part 'showtime_slot_dto.g.dart';

@JsonSerializable(createToJson: false)
class ShowtimeSlotDto {
  @JsonKey(name: 'showtime_id')
  final String showtimeId;

  @JsonKey(name: 'start_iso')
  final String startIso;

  @JsonKey(name: 'end_iso')
  final String endIso;

  @JsonKey(name: 'hall_id')
  final int hallId;

  const ShowtimeSlotDto({
    required this.showtimeId,
    required this.startIso,
    required this.endIso,
    required this.hallId,
  });

  factory ShowtimeSlotDto.fromJson(Map<String, dynamic> json) =>
      _$ShowtimeSlotDtoFromJson(json);
}

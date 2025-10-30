import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/info_row.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/legend.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/screen_line.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/seat_grid.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/tag.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/schedule/section_title.dart';

class SeatSelectionFormData {
  final String title;
  final String posterUrl;
  final String cinemaName;
  final String cinemaAddr;
  final String hallName;
  final String dateText;
  final String timeRange;
  final bool is3D;

  final List<HallRow> rows;
  final Set<String> selected;
  final int selectedCount;

  final int movieId;
  final String showtimeId;
  final String date; // YYYY-MM-DD
  final String startIso;
  final String endIso;
  final String quality; // "2D" / "3D"

  const SeatSelectionFormData({
    required this.title,
    required this.posterUrl,
    required this.cinemaName,
    required this.cinemaAddr,
    required this.hallName,
    required this.dateText,
    required this.timeRange,
    required this.is3D,
    required this.rows,
    required this.selected,
    required this.selectedCount,
    required this.movieId,
    required this.showtimeId,
    required this.date,
    required this.startIso,
    required this.endIso,
    required this.quality,
  });
}

class SeatSelectionFormActions {
  final VoidCallback onBack;
  final Future<void> Function() onRefresh;
  final void Function(String seatCode) onToggleSeat;
  final VoidCallback onClear;
  final VoidCallback onContinue;

  const SeatSelectionFormActions({
    required this.onBack,
    required this.onRefresh,
    required this.onToggleSeat,
    required this.onClear,
    required this.onContinue,
  });
}

class SeatSelectionForm extends StatefulWidget {
  const SeatSelectionForm({
    super.key,
    required this.data,
    required this.actions,
  });

  final SeatSelectionFormData data;
  final SeatSelectionFormActions actions;

  @override
  State<SeatSelectionForm> createState() => _SeatSelectionFormState();
}

class _SeatSelectionFormState extends State<SeatSelectionForm>
    with AutomaticKeepAliveClientMixin {
  final TransformationController _seatTc = TransformationController();
  final GlobalKey _seatGridAreaKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _seatTc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      color: cs.surface,
      child: InstantRefreshScrollView(
        onRefresh: widget.actions.onRefresh,
        refreshBlockAreas: [_seatGridAreaKey],
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: cs.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: widget.actions.onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            centerTitle: true,
            title: Text(
              'Select Seat',
              textAlign: TextAlign.center,
              style: tt.headlineMedium?.copyWith(color: cs.primary),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: widget.data.posterUrl.isEmpty
                                  ? Container(color: Colors.black26)
                                  : Image.network(
                                widget.data.posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: Colors.black26),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InfoRow(
                                icon: Icons.place_outlined,
                                text:
                                '${widget.data.cinemaName}${widget.data.hallName.isNotEmpty ? ', ${widget.data.hallName}' : ''}\n${widget.data.cinemaAddr}',
                              ),
                              const SizedBox(height: 6),
                              InfoRow(
                                icon: Icons.calendar_today_outlined,
                                text: widget.data.dateText,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: InfoRow(
                                      icon: Icons.schedule,
                                      text: widget.data.timeRange,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Tag(text: widget.data.is3D ? '3D' : '2D'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    key: _seatGridAreaKey,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionTitle('Select seats',
                            color: cs.onSurface, textTheme: tt),
                        const SizedBox(height: 12),

                        ScreenLine(color: cs.primary.withOpacity(0.35)),
                        const SizedBox(height: 10),

                        SeatGrid(
                          rows: widget.data.rows,
                          selected: widget.data.selected,
                          onToggle: widget.actions.onToggleSeat,
                          controller: _seatTc,
                        ),

                        const SizedBox(height: 10),
                        Legend(cs: cs),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  if (widget.data.selectedCount > 0)
                    TextButton(
                      onPressed: widget.actions.onClear,
                      child: Text(
                          'Clear selection (${widget.data.selectedCount})'),
                    ),
                  const SizedBox(height: 8),

                  PrimaryButton(
                    text: 'Continue',
                    onPressed: widget.actions.onContinue,
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    bottomSpacing: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
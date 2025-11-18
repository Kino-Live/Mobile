import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/info_row.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/selected_tickets_panel.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/tag.dart';
import 'package:kinolive_mobile/presentation/widgets/general/instant_refresh_scroll_view.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class PaymentFormData {
  final String movieTitle;
  final String posterUrl;

  final String cinemaName;
  final String cinemaAddress;
  final String hallName;

  final String dateText;
  final String timeRange;
  final bool is3D;

  final List<HallRow> rows;
  final List<String> selectedCodes;
  final double totalPrice;
  final String totalCurrency;

  const PaymentFormData({
    required this.movieTitle,
    required this.posterUrl,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.hallName,
    required this.dateText,
    required this.timeRange,
    required this.is3D,
    required this.rows,
    required this.selectedCodes,
    required this.totalPrice,
    required this.totalCurrency,
  });
}

class PaymentFormActions {
  final VoidCallback onBack;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onPay;

  const PaymentFormActions({
    required this.onBack,
    required this.onRefresh,
    required this.onPay,
  });
}

class PaymentForm extends StatelessWidget {
  const PaymentForm({
    super.key,
    required this.data,
    required this.actions,
  });

  final PaymentFormData data;
  final PaymentFormActions actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      color: cs.surface,
      child: InstantRefreshScrollView(
        onRefresh: actions.onRefresh,
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: cs.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: actions.onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            centerTitle: true,
            title: Text(
              'Payment',
              textAlign: TextAlign.center,
              style: tt.headlineMedium?.copyWith(color: cs.primary),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                              child: data.posterUrl.isEmpty
                                  ? Container(color: Colors.black26)
                                  : Image.network(
                                data.posterUrl,
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
                                data.movieTitle,
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
                                '${data.cinemaName}${data.hallName.isNotEmpty ? ', ${data.hallName}' : ''}\n${data.cinemaAddress}',
                              ),
                              const SizedBox(height: 6),
                              InfoRow(
                                icon: Icons.calendar_today_outlined,
                                text: data.dateText,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: InfoRow(
                                      icon: Icons.schedule,
                                      text: data.timeRange,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Tag(text: data.is3D ? '3D' : '2D'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SelectedTicketsPanel(
                    rows: data.rows,
                    selectedCodes: data.selectedCodes,
                    totalPrice: data.totalPrice,
                    totalCurrency: data.totalCurrency,
                    maxVisibleItems: 6,
                  ),

                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: 'Pay by LiqPay',
                    onPressed: actions.onPay,
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    bottomSpacing: 0,
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
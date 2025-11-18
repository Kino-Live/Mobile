import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/info_row.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/selected_tickets_panel.dart';
import 'package:kinolive_mobile/presentation/widgets/booking/seat_selection/tag.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';

class PaymentScreenArgs {
  final HallInfo hallInfo;
  final List<String> selectedCodes;
  final double totalPrice;
  final String totalCurrency;
  final String movieTitle;
  final String posterUrl;

  final String dateText;
  final String timeRange;
  final bool is3D;

  const PaymentScreenArgs({
    required this.hallInfo,
    required this.selectedCodes,
    required this.totalPrice,
    required this.totalCurrency,
    required this.movieTitle,
    required this.posterUrl,

    required this.dateText,
    required this.timeRange,
    required this.is3D,
  });
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.args});
  final PaymentScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final cinema = args.hallInfo.cinema;
    final hall = args.hallInfo.hall;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text(
          'Payment',
          style: tt.headlineMedium?.copyWith(color: cs.primary),
        ),
      ),
      body: SafeArea(
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
                          child: args.posterUrl.isEmpty
                              ? Container(color: Colors.black26)
                              : Image.network(
                            args.posterUrl,
                            fit: BoxFit.cover,
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
                            args.movieTitle,
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
                            '${cinema.name}${hall.name.isNotEmpty ? ', ${hall.name}' : ''}\n${cinema.city}, ${cinema.address}',
                          ),
                          const SizedBox(height: 6),

                          InfoRow(
                            icon: Icons.calendar_today_outlined,
                            text: args.dateText,
                          ),
                          const SizedBox(height: 6),

                          Row(
                            children: [
                              Expanded(
                                child: InfoRow(
                                  icon: Icons.schedule,
                                  text: args.timeRange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tag(text: args.is3D ? '3D' : '2D'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: SelectedTicketsPanel(
                    rows: hall.rows,
                    selectedCodes: args.selectedCodes,
                    totalPrice: args.totalPrice,
                    totalCurrency: args.totalCurrency,
                    maxVisibleItems: 6,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              PrimaryButton(
                text: 'Pay by LiqPay',
                onPressed: () {
                  
                },
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
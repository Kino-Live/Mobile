import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';

class SelectedTicketsPanel extends StatelessWidget {
  const SelectedTicketsPanel({
    super.key,
    required this.rows,
    required this.selectedCodes,
    required this.totalPrice,
    required this.totalCurrency,
    this.maxVisibleItems = 3,
  });

  final List<HallRow> rows;
  final List<String> selectedCodes;
  final double totalPrice;
  final String totalCurrency;
  final int maxVisibleItems;

  HallSeat? _findSeat(String code) {
    for (final row in rows) {
      for (final seat in row.seats) {
        if (seat.code == code) return seat;
      }
    }
    return null;
  }

  String _formatPrice(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    const double rowHeight = 24;
    final int rowsCount = selectedCodes.length;
    final int visibleRows =
    rowsCount == 0 ? 1 : rowsCount.clamp(1, maxVisibleItems);
    final double boxHeight = visibleRows * rowHeight;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Selected tickets',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: boxHeight,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: selectedCodes.length,
                itemBuilder: (context, index) {
                  final code = selectedCodes[index];

                  String row = '';
                  String seatNum = '';
                  for (int i = 0; i < code.length; i++) {
                    final ch = code[i];
                    if (int.tryParse(ch) != null) {
                      row = code.substring(0, i);
                      seatNum = code.substring(i);
                      break;
                    }
                  }
                  row = row.isEmpty ? code : row;
                  seatNum = seatNum.isEmpty ? '' : seatNum;

                  final seat = _findSeat(code);
                  final price = seat?.price ?? 0;
                  final currency = seat?.currency ?? totalCurrency;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Row $row, Seat $seatNum',
                          style: tt.bodyMedium,
                        ),
                        Text(
                          '${_formatPrice(price)} $currency',
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_formatPrice(totalPrice)} ${totalCurrency.isEmpty ? '' : totalCurrency}',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

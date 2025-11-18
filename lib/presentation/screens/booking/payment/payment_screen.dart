import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/payment_form.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

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

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.args});
  final PaymentScreenArgs args;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isPaying = false;

  Future<void> _handlePay() async {
    if (_isPaying) return;

    setState(() => _isPaying = true);

    final createOrder = ref.read(createOrderProvider);
    final showtime = widget.args.hallInfo.showtime;
    final hall = widget.args.hallInfo.hall;

    try {
      final order = await createOrder(
        showtimeId: showtime.id,
        movieId: showtime.movieId,
        hallId: hall.id,
        seats: widget.args.selectedCodes,
        totalAmount: widget.args.totalPrice,
        currency: widget.args.totalCurrency,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment successful. Order №${order.id}',
            textAlign: TextAlign.center,
          ),
        ),
      );

      // context.go(ordersHistoryPath);
      context.pop();
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message, textAlign: TextAlign.center),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment error', textAlign: TextAlign.center),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hallInfo = widget.args.hallInfo;
    final cinema = hallInfo.cinema;
    final hall = hallInfo.hall;

    final data = PaymentFormData(
      movieTitle: widget.args.movieTitle,
      posterUrl: widget.args.posterUrl,
      cinemaName: cinema.name,
      cinemaAddress: '${cinema.city}, ${cinema.address}',
      hallName: hall.name,
      dateText: widget.args.dateText,
      timeRange: widget.args.timeRange,
      is3D: widget.args.is3D,
      rows: hall.rows,
      selectedCodes: widget.args.selectedCodes,
      totalPrice: widget.args.totalPrice,
      totalCurrency: widget.args.totalCurrency,
    );

    final actions = PaymentFormActions(
      onBack: () => context.pop(),
      onPay: _handlePay,
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: _isPaying,
          child: PaymentForm(
            data: data,
            actions: actions,
          ),
        ),
      ),
    );
  }
}
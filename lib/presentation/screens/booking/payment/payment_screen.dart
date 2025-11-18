import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/payment_form.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/liqpay_webview_page.dart';
import 'package:kinolive_mobile/presentation/viewmodels/booking/payment_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

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

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key, required this.args});
  final PaymentScreenArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hallInfo = args.hallInfo;
    final cinema = hallInfo.cinema;
    final hall = hallInfo.hall;

    final vmState = ref.watch(paymentVmProvider(args));

    final data = PaymentFormData(
      movieTitle: args.movieTitle,
      posterUrl: args.posterUrl,
      cinemaName: cinema.name,
      cinemaAddress: '${cinema.city}, ${cinema.address}',
      hallName: hall.name,
      dateText: args.dateText,
      timeRange: args.timeRange,
      is3D: args.is3D,
      rows: hall.rows,
      selectedCodes: args.selectedCodes,
      totalPrice: args.totalPrice,
      totalCurrency: args.totalCurrency,
    );

    final actions = PaymentFormActions(
      onBack: () => context.pop(),
      onRefresh: () async {
        return;
      },
      onPay: () => _handlePay(context, ref),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: vmState.isProcessing,
          child: PaymentForm(
            data: data,
            actions: actions,
          ),
        ),
      ),
    );
  }

  Future<void> _handlePay(BuildContext context, WidgetRef ref) async {
    final vm = ref.read(paymentVmProvider(args).notifier);

    final payment = await vm.initLiqpay(args);
    if (payment == null) {
      final state = ref.read(paymentVmProvider(args));
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.error ?? 'Failed to init payment',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return;
    }

    final bool? paid = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LiqPayWebViewPage(
          data: payment.data,
          signature: payment.signature,
        ),
      ),
    );

    if (paid != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Payment not completed',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    await vm.createOrderAfterLiqpay(args);

    final state = ref.read(paymentVmProvider(args));

    if (state.isSuccess && state.order != null) {
      context.goNamed(
        paymentSuccessName,
        pathParameters: {'orderId': state.order!.id},
      );
    } else if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.error ?? 'Payment error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}

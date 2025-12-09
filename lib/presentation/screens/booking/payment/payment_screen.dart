import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/payment_form.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/liqpay_webview_page.dart';
import 'package:kinolive_mobile/presentation/viewmodels/booking/payment_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/promocodes_history_vm.dart';
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

class PaymentScreen extends HookConsumerWidget {
  const PaymentScreen({super.key, required this.args});
  final PaymentScreenArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hallInfo = args.hallInfo;
    final cinema = hallInfo.cinema;
    final hall = hallInfo.hall;

    final vmState = ref.watch(paymentVmProvider(args));
    final promocodesState = ref.watch(promocodesHistoryVmProvider);
    
    final selectedPromocode = useState<Promocode?>(null);

    useEffect(() {
      Future.microtask(() {
        ref.read(promocodesHistoryVmProvider.notifier).load();
      });
      return null;
    }, const []);

    final formData = PaymentFormData(
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
      promocodes: promocodesState.promocodes,
      selectedPromocode: selectedPromocode.value,
      onPromocodeSelected: (promo) {
        selectedPromocode.value = promo;
        ref.read(paymentVmProvider(args).notifier).setSelectedPromocode(promo);
      },
    );

    final formActions = PaymentFormActions(
      onBack: () => context.pop(),
      onRefresh: () async {
        await ref.read(promocodesHistoryVmProvider.notifier).load();
      },
      onPay: () => _handlePay(context, ref, selectedPromocode.value, formData),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LoadingOverlay(
          loading: vmState.isProcessing,
          child: PaymentForm(
            data: formData,
            actions: formActions,
          ),
        ),
      ),
    );
  }

  Future<void> _handlePay(BuildContext context, WidgetRef ref, Promocode? promocode, PaymentFormData formData) async {
    final vm = ref.read(paymentVmProvider(args).notifier);

    if (formData.finalAmount == 0) {
      await vm.createOrderAfterLiqpay(args, promocode: promocode);
      
      final state = ref.read(paymentVmProvider(args));
      
      if (state.isSuccess && state.order != null) {
        context.goNamed(
          paymentSuccessName,
          pathParameters: {'orderId': state.order!.id},
        );
        return;
      }
      
      if (state.hasError) {
        _showSnack(context, state.error ?? 'Failed to create order');
      }
      return;
    }

    final payment = await vm.initLiqpay(args, promocode: promocode);
    if (payment == null) {
      final state = ref.read(paymentVmProvider(args));
      if (state.hasError) {
        _showSnack(context, state.error ?? 'Failed to init payment');
      }
      return;
    }

    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LiqPayWebViewPage(
          data: payment.data,
          signature: payment.signature,
        ),
      ),
    );

    final liqpayStatus = await vm.checkLiqpayStatus();
    if (liqpayStatus == null) {
      _showSnack(context, 'Failed to check payment status');
      return;
    }

    debugPrint('LiqPay status = $liqpayStatus');

    final isSuccess = liqpayStatus == 'success' || liqpayStatus == 'sandbox';

    if (!isSuccess) {
      _showSnack(context, 'Payment not completed');
      return;
    }

    await vm.createOrderAfterLiqpay(args, promocode: promocode);

    final state = ref.read(paymentVmProvider(args));

    if (state.isSuccess && state.order != null) {
      context.goNamed(
        paymentSuccessName,
        pathParameters: {'orderId': state.order!.id},
      );
      return;
    }

    if (state.hasError) {
      _showSnack(context, state.error ?? 'Payment error');
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
      ),
    );
  }
}

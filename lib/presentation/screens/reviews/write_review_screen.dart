import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/presentation/screens/reviews/write_review_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/reviews/write_review_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/loading_overlay.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  const WriteReviewScreen({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  bool _hasUnsavedChanges = false;

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeReviewVmProvider);
    final isLoading = state.isLoading;

    ref.listen(writeReviewVmProvider, (prev, next) {
      if (next.status == WriteReviewStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textAlign: TextAlign.center),
          ),
        );
        ref.read(writeReviewVmProvider.notifier).clearError();
      }
      if (next.status == WriteReviewStatus.success) {
        if (mounted) {
          setState(() {
            _hasUnsavedChanges = false;
          });
        }
        
        final navigatorContext = context;
        final scaffoldMessenger = ScaffoldMessenger.of(navigatorContext);
        
        if (mounted && navigatorContext.mounted) {
          Navigator.of(navigatorContext).pop(true);
        }
        
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scaffoldMessenger.mounted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Review submitted successfully', textAlign: TextAlign.center),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }
    });

    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            'Leave a Review',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: LoadingOverlay(
            loading: isLoading,
            child: WriteReviewForm(
              order: widget.order,
              onChanged: () {
                if (mounted) {
                  setState(() {
                    _hasUnsavedChanges = true;
                  });
                }
              },
              onCancel: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop && mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}


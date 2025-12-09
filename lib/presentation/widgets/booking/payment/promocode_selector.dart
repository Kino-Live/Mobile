import 'package:flutter/material.dart';
import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';

class PromocodeSelector extends StatelessWidget {
  final List<Promocode> promocodes;
  final Promocode? selectedPromocode;
  final Function(Promocode?) onPromocodeSelected;
  final double totalAmount;
  final String currency;

  const PromocodeSelector({
    super.key,
    required this.promocodes,
    this.selectedPromocode,
    required this.onPromocodeSelected,
    required this.totalAmount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final sortedPromocodes = List<Promocode>.from(promocodes)
      ..sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        
        final aFits = a.amount <= totalAmount && a.currency == currency;
        final bFits = b.amount <= totalAmount && b.currency == currency;
        
        if (aFits && !bFits) return -1;
        if (!aFits && bFits) return 1;
        
        if (aFits && bFits) {
          return b.amount.compareTo(a.amount);
        }
        
        return b.amount.compareTo(a.amount);
      });

    if (sortedPromocodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promocode',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (selectedPromocode != null)
                TextButton(
                  onPressed: () => onPromocodeSelected(null),
                  child: Text(
                    'Remove',
                    style: tt.labelMedium?.copyWith(
                      color: cs.error,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (selectedPromocode != null)
            _SelectedPromocodeCard(
              promocode: selectedPromocode!,
              totalAmount: totalAmount,
              currency: currency,
            )
          else
            _PromocodeDropdown(
              promocodes: sortedPromocodes,
              totalAmount: totalAmount,
              currency: currency,
              onSelected: onPromocodeSelected,
            ),
        ],
      ),
    );
  }
}

class _SelectedPromocodeCard extends StatelessWidget {
  final Promocode promocode;
  final double totalAmount;
  final String currency;

  const _SelectedPromocodeCard({
    required this.promocode,
    required this.totalAmount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
              Text(
                promocode.code,
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Applied',
              style: tt.labelSmall?.copyWith(
                color: cs.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromocodeDropdown extends StatelessWidget {
  final List<Promocode> promocodes;
  final double totalAmount;
  final String currency;
  final Function(Promocode) onSelected;

  const _PromocodeDropdown({
    required this.promocodes,
    required this.totalAmount,
    required this.currency,
    required this.onSelected,
  });

  void _showPromocodeDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final activePromocodes = promocodes.where((p) => p.isActive).toList();

    if (activePromocodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No active promocodes available',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    final matchingCurrencyPromocodes = activePromocodes.where((p) =>
      p.currency == currency
    ).toList();
    
    if (matchingCurrencyPromocodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No active promocodes available',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    Promocode? bestPromocode;
    bestPromocode = matchingCurrencyPromocodes.reduce((a, b) {
      final diffA = (a.amount - totalAmount).abs();
      final diffB = (b.amount - totalAmount).abs();
      if (diffA == diffB) {
        return a.amount <= totalAmount ? a : b;
      }
      return diffA < diffB ? a : b;
    });

    final best = bestPromocode;
    final bestAmount = best.amount;
    final otherPromocodes = matchingCurrencyPromocodes.where((p) => p.id != best.id).toList();
    final bestIsCheaper = otherPromocodes.isNotEmpty && 
                         otherPromocodes.every((p) => bestAmount < p.amount);
    
    final sortedPromocodes = List<Promocode>.from(matchingCurrencyPromocodes)
      ..sort((a, b) {
        if (a.id == best.id) return -1;
        if (b.id == best.id) return 1;
        
        final aIsOther = a.id != best.id;
        final bIsOther = b.id != best.id;
        
        if (aIsOther && bIsOther) {
          if (bestIsCheaper) {
            return a.amount.compareTo(b.amount);
          } else {
            return b.amount.compareTo(a.amount);
          }
        }
        
        return 0;
      });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select Promocode',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: sortedPromocodes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final promocode = sortedPromocodes[index];
                    final fits = promocode.amount <= totalAmount && promocode.currency == currency;
                    final isBest = bestPromocode != null && promocode.id == bestPromocode.id;
                    final discount = promocode.amount > totalAmount ? totalAmount : promocode.amount;
                    
                    return InkWell(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        onSelected(promocode);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isBest ? cs.primary.withOpacity(0.3) : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    promocode.code,
                                    style: tt.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isBest)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: cs.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Best',
                                      style: tt.labelSmall?.copyWith(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${promocode.amount.toStringAsFixed(2)} ${promocode.currency} ${fits ? '(saves ${discount.toStringAsFixed(2)})' : '(exceeds order)'}',
                              style: tt.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final activePromocodes = promocodes.where((p) => p.isActive).toList();

    if (activePromocodes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'No active promocodes available',
          style: tt.bodyMedium?.copyWith(
            color: Colors.white60,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return InkWell(
      onTap: () => _showPromocodeDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select promocode',
              style: tt.bodyMedium,
            ),
            Icon(
              Icons.arrow_drop_down,
              color: cs.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}


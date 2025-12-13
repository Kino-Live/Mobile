import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyFilterVmProvider =
    NotifierProvider<HistoryFilterVm, HistoryFilterState>(
  () => HistoryFilterVm(),
);

enum HistoryFilterCategory { all, online, paid, refunded, cancelled }

class HistoryFilterState {
  final String query;
  final HistoryFilterCategory selectedCategory;

  const HistoryFilterState({
    this.query = '',
    this.selectedCategory = HistoryFilterCategory.all,
  });

  bool get hasActiveFilters => query.isNotEmpty || selectedCategory != HistoryFilterCategory.all;

  HistoryFilterState copyWith({
    String? query,
    HistoryFilterCategory? selectedCategory,
  }) {
    return HistoryFilterState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class HistoryFilterVm extends Notifier<HistoryFilterState> {
  @override
  HistoryFilterState build() {
    return const HistoryFilterState();
  }

  void setQuery(String value) {
    state = state.copyWith(query: value);
  }

  void clearQuery() {
    state = state.copyWith(query: '');
  }

  void setCategory(HistoryFilterCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void clearFilters() {
    state = const HistoryFilterState();
  }
}


import 'package:flutter/material.dart';

class InstantRefreshScrollView extends StatelessWidget {
  const InstantRefreshScrollView({
    super.key,
    required this.slivers,
    this.onRefresh,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;
  final ScrollPhysics physics;

  Future<void> _instant() async {
    if (onRefresh != null) {
      onRefresh!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _instant,
      child: CustomScrollView(
        physics: physics,
        slivers: slivers,
      ),
    );
  }
}

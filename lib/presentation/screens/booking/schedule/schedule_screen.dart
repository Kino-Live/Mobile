import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/app/router/router_path.dart';
import 'package:kinolive_mobile/presentation/viewmodels/billboard_vm.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({
    super.key,
    this.initialIndex = 0,
    required this.onResetUi,
    this.onIndexChanged,
  });

  final int initialIndex;

  final VoidCallback onResetUi;

  final ValueChanged<int>? onIndexChanged;

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  Future<void> _handleTap(int next) async {
    final prev = _current;

    widget.onResetUi();

    if (next == 0) {
      // Billboard
      if (prev == 0) {
        await ref.read(billboardVmProvider.notifier).load();
        return;
      }

      context.go(billboardPath);
    } else if (next == 1) {
      // TODO: navigate to the second screen/route if it appears
    } else if (next == 2) {
      if (prev == 2) {
        // TODO: provider for profile
        // await ref.read(billboardVmProvider.notifier).load();
        return;
      }

      context.go(profilePath);
    }

    if (!mounted) return;
    setState(() => _current = next);
    widget.onIndexChanged?.call(_current);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      currentIndex: _current,
      onTap: _handleTap,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_creation_outlined),
          label: 'Billboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          label: 'Coming soon',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

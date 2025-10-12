import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinolive_mobile/presentation/screens/billboard/billboard_form.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

class BillboardScreen extends ConsumerStatefulWidget {
  const BillboardScreen({super.key});

  @override
  ConsumerState<BillboardScreen> createState() => _BillboardScreenState();
}

class _BillboardScreenState extends ConsumerState<BillboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (prev, next) {
      final wasAuthed = prev?.isAuthenticated == true;
      final nowAuthed = next.isAuthenticated;

      if (wasAuthed && !nowAuthed) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          const SnackBar(content: Text('Logged out', textAlign: TextAlign.center,)),
        );
      }
    });

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'KinoLive',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton.filled(
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              onPressed: () {},
              icon: Icon(Icons.search, color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
      body: const SafeArea(child: BillboardForm()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() => _currentIndex = index);

          switch (index) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              await ref.read(authStateProvider.notifier).logout();
              break;
          }
        },
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kinolive_mobile/screens/billboard/billboard_form.dart';

class BillboardScreen extends StatefulWidget {
  const BillboardScreen({super.key});

  @override
  State<BillboardScreen> createState() => _BillboardScreenState();
}

class _BillboardScreenState extends State<BillboardScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
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
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
          ),
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
      body: SafeArea(
        child: BillboardForm()
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
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
import 'package:flutter/material.dart';

class CastCard extends StatelessWidget {
  const CastCard({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e.characters.first).join()
        : '?';
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF23262B),
          child: Text(initials, style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 84,
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }
}


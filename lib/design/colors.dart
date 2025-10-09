import 'package:flutter/material.dart';

// green: FF25AA68
// grey: FF989898
// white: FFF1F1F1
// blue: FF648DDB

// inputpanel grey: FF2B2B38
// inputpanelText grey: FF4A4B56

//background: FF161621

const Color myBlue = Color(0xFF719AE4);

final ColorScheme customColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF25AA68),
  brightness: Brightness.dark,
).copyWith(
  //
  //
  primaryContainer: Color(0xFF25AA68),
  onPrimaryContainer: Color(0xFF161621),
  surface: Color(0xFF161621),
  // surfaceContainer: Color(0xFF2B2B38),
  onSurface: Color(0xFFF1F1F1),
  outline: Color(0xFFF1F1F1),
  onSurfaceVariant: Color(0xFF989898),
  outlineVariant: Color(0xFF989898),
);
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

const appLocale = Locale('en', 'GB');

const appSupportedLocales = [
  Locale('en', 'GB'),
];

const appLocalizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

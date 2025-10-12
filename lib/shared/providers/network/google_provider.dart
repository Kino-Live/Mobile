import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: const ['email', 'profile'],
    // serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  );
});
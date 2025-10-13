import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: const ['email', 'profile'],
    // serverClientId: '557435188455-kf4mmugvnmfgjb86cjrcrcgn9vqli7bq.apps.googleusercontent.com',
  );
});
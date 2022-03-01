import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_lyft/screens/home_screen.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? actualCode;

  bool isLoginLoading = false;

  Future<void>? getCodeWithPhoneNumber(
      BuildContext context, String? phoneNumber) async {
    isLoginLoading = true;

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential auth) async {
          await _auth.signInWithCredential(auth).then((UserCredential? value) {
            if (value != null && value.user != null) {
              Navigator.of(context).pushNamed(HomePage.routeName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(
                  'Invalid code/invalid authentication',
                  style: TextStyle(color: Colors.white),
                ),
              ));
            }
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'Something has gone wrong, please try later',
                style: TextStyle(color: Colors.white),
              ),
            ));
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              authException.message.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ));
          isLoginLoading = false;
        },
        codeSent: (String? verificationId, [int? forceResendingToken]) async {
          actualCode = verificationId;
        },
        codeAutoRetrievalTimeout: (String? verificationId) {
          actualCode = verificationId;
        });
  }
}

import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_lyft/screens/home_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:uber_lyft/providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, this.phone, this.countryCode}) : super(key: key);
  static const routeName = '/otp';
  final String? phone;
  final String? countryCode;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FocusNode _pinFocus = FocusNode();
  TextEditingController phoneController = TextEditingController();
  String? _verificationCode;
  final _auth = FirebaseAuth.instance;

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${widget.countryCode! + widget.phone!}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.of(context).pushNamed(HomePage.routeName);
            }
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
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    // final _phoneAuth = Provider.of<Auth>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset('assets/images/verification.png')),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Verication',
                  style: TextStyle(
                      fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                    'Enter verification code that sent to ${widget.phone} by SMS'),
                Container(
                  height: 40,
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Platform.isIOS
                      ? CupertinoTextField(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          controller: phoneController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          placeholder: '1 2 3 4',
                        )
                      : TextField(
                          focusNode: _pinFocus,
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: '1 2 3 4',
                          ),
                          onSubmitted: (pin) async {
                            try {
                              await _auth
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: _verificationCode!,
                                          smsCode: pin))
                                  .then((value) async {
                                if (value.user != null) {
                                  Navigator.of(context)
                                      .pushNamed(HomePage.routeName);
                                }
                              });
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('invalid OTP')));
                            }
                          },
                        ),
                ),
              ]),
        ),
      ),
    );
  }
}

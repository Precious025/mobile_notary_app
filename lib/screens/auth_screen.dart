import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_screen.dart';
import 'otp_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _controller = TextEditingController();
  String? digitCode = "+00";
  final FirebaseAuth? _auth = FirebaseAuth.instance;

  _buildContainer(String? text, String? image, {Function? signIn}) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(242, 242, 242, 0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () => signIn,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      image!,
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Center(
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> _signUp(BuildContext context) async {
    final GoogleSignIn? googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn!.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential? authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication!.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      final UserCredential? result =
          await _auth!.signInWithCredential(authCredential!);
      // User? user = result!.user;

      if (result != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: _deviceSize.width,
        height: _deviceSize.height,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/Logo.png'),
              const Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Welcome to A1.Mobile Notary, enter your details below to continue .',
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Enter your Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    fillColor: const Color.fromRGBO(242, 242, 242, 0.95),
                    hintText: 'Enter your phone',
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CountryCodePicker(
                        onChanged: (countryCode) {
                          setState(() {
                            digitCode = countryCode.dialCode.toString();
                          });
                        },
                        favorite: const ["+1", "US"],
                        initialSelection: "US",
                        showOnlyCountryWhenClosed: false,
                        showCountryOnly: false,
                      ),
                    ),
                  ),
                  maxLength: 12,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  child: const Text('REGISTER'),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => OtpScreen(
                            phone: _controller.text,
                            countryCode: digitCode,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please enter a phone number',
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              _buildContainer(
                'Continue with Google',
                'assets/images/google.png',
                signIn: (context) => _signUp(context),
              ),
              _buildContainer('Continue with Apple', 'assets/images/apple.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text(
                      "Already have an account?",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Login')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isSignIn = false;
  bool google = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await signInWithGoogle();

                  debugPrint("Auth ----------->> ${auth.currentUser!.displayName}");
                },
                child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreenAccent,
                  ),
                  child: const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    debugPrint("Google Auth accessToken ------------->>>${googleAuth!.accessToken}");
    debugPrint("Google Auth idToken ------------->>>${googleAuth.idToken}");

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    debugPrint("credential ------------->>>$credential");

    googleSignIn.disconnect();

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }
}
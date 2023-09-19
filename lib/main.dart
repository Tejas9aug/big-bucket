

import 'package:big_bucket/phone_auth/register_with_phone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'second.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    double d1 =MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: first(),
    );
  }
}

class first extends StatefulWidget {
  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController _controller = TextEditingController();
  GoogleSignInAccount? _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String url = "";
  String name = "";
  String email = "";
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  GoogleSignInAuthentication? googleAuth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animation.json",),
            SizedBox(
              height: 90,
            ),

            Text(
              'Personal Drive App',
              style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.indigo[900], fontSize: MediaQuery
                .of(context)
                .size
                .width * 0.07), fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: MaterialButton(
                color: Color.fromARGB(255, 255, 255, 255),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      //color: Colors.grey,
                      height: 50.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign In with Google",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.indigo[900], fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                onPressed: () async {
                  var f = await signInWithGoogle();
                  User? user = _auth.currentUser;
                  if (f != null) {
                    var de = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .get();

                    if (de != null) {
                      ref.doc(user.uid).set({
                        'name': name,
                        'url': url,
                        'email': email,
                      });
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (second(
                          url: url,
                        )),
                      ),
                    );
                  }
                },
              ),
            ),
        SizedBox(height: 20,),
        ElevatedButton(
          onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegisterWithPhone()));},
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          child: Text("Phone Auth", style: const TextStyle(fontSize: 16)),
        ),


            // Padding(
            //   padding: EdgeInsets.only(bottom: 50),
            // ),

            SizedBox(
              height: 20,
            ),
            

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Big',
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black, fontSize: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05, fontWeight: FontWeight.w600)),
                ),
                Text(
                  'Bucket',
                   style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.black, fontSize: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
             // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 120
                  ,),
                Text("The Safest Storage",style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.black, fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02, fontWeight: FontWeight.w600)),)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print(googleUser);
    url = googleUser!.photoUrl.toString();
    name = googleUser.displayName.toString();
    email = googleUser.email;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}


import 'package:big_bucket/phone_auth/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterWithPhone extends StatefulWidget {
  const RegisterWithPhone({Key? key}) : super(key: key);

  @override
  State<RegisterWithPhone> createState() => _RegisterWithPhoneState();
}

class _RegisterWithPhoneState extends State<RegisterWithPhone> {
  final _auth=FirebaseAuth.instance;
  final phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: phoneController,

          ),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
            _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted: (_){

                },
                verificationFailed: (e){
                  print(e.toString());
                },
                codeSent: (verificationId,token){
                  Navigator.push(context, MaterialPageRoute(builder: (context)
                  =>VerifyScreen(verificationId: verificationId)));

                },
                codeAutoRetrievalTimeout: (e){
                  print(e);
                });
          }, child: const Center(
            child: Text("Register"),
          ))
        ],
      ),
    );
  }
}
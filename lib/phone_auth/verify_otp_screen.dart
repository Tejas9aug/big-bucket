import 'package:big_bucket/second.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyScreen extends StatefulWidget {
  final String verificationId;
  const VerifyScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _auth=FirebaseAuth.instance;
  final otpController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: otpController,

          ),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: ()async{
            final credential=PhoneAuthProvider.credential(
                verificationId: widget.verificationId, smsCode: otpController.text);
            await _auth.signInWithCredential(credential).then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)
              => second(url: '',)));
            });
          }, child: const Center(
            child: Text("Verify"),
          ))
        ],
      ),
    );
  }
}
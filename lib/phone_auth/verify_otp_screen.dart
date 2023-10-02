import 'package:big_bucket/second.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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
    double d1=MediaQuery.of(context).size.height;
    double d2=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0.0,
        centerTitle:true,
        title: Text("Register", style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.indigo[900], fontSize: MediaQuery
                .of(context)
                .size
                .width * 0.07), fontWeight: FontWeight.w600)),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(d2*0.11,d1*0.2,d2*0.11,d1*0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/animation2.json",),
            
              SizedBox(height:d1*0.15),
              TextFormField(

                controller: otpController,

                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white, width: MediaQuery
                          .of(context)
                          .size
                          .height * 0.003),
                      borderRadius: BorderRadius.circular(MediaQuery
                          .of(context)
                          .size
                          .width * 0.1)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue, width: MediaQuery
                          .of(context)
                          .size
                          .height * 0.003),
                      borderRadius: BorderRadius.circular(MediaQuery
                          .of(context)
                          .size
                          .width * 0.1)
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue, width: MediaQuery
                          .of(context)
                          .size
                          .height * 0.003),
                      borderRadius: BorderRadius.circular(MediaQuery
                          .of(context)
                          .size
                          .width * 0.1)
                  ),
                  hintText: "OTP",
                ),

              ),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: ()async{
                final credential=PhoneAuthProvider.credential(
                    verificationId: widget.verificationId, smsCode: otpController.text);
                await _auth.signInWithCredential(credential).then((value){
                  Navigator.push(context, MaterialPageRoute(builder: (context)
                  => second()));
                });
              }, child: const Center(
                child: Text("Verify"),
              )),
              SizedBox(
                height: d1*0.1,
              ),

              Text("By clicking continue you agree to BigBucket.com's",
                  style: GoogleFonts.montserrat(textStyle:
                  TextStyle(color: Color(0xFF979797),fontWeight: FontWeight.w600,fontSize: d2*0.0295))),
              RichText(
                text: TextSpan(
                    text: "Terms and Conditions ",
                    style:GoogleFonts.montserrat(textStyle: TextStyle(color: Color(0xFF181725),fontWeight: FontWeight.w600)),
                    children: [
                      TextSpan(
                          text: "and ",
                          style:GoogleFonts.montserrat(textStyle: TextStyle(color: Color(0xFF979797),fontWeight: FontWeight.w600)),
                          children: [
                            TextSpan(
                              text: "Privacy Policy",
                              style:GoogleFonts.montserrat(textStyle: TextStyle(color: Color(0xFF181725),fontWeight: FontWeight.w600)),

                            )
                          ]
                      )
                    ]
                ),
              ),
            ],
            
       
          ),
        ),
      ),
    );
  }
}
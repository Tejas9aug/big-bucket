
import 'package:big_bucket/phone_auth/verify_otp_screen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RegisterWithPhone extends StatefulWidget {
  const RegisterWithPhone({Key? key}) : super(key: key);

  @override
  State<RegisterWithPhone> createState() => _RegisterWithPhoneState();
}

class _RegisterWithPhoneState extends State<RegisterWithPhone> {
  final _auth=FirebaseAuth.instance;
  final phoneController=TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "+91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );


  @override
  Widget build(BuildContext context) {
    double d1=MediaQuery.of(context).size.height;
    double d2=MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0.0,
        centerTitle:true,
          title: Text("Register", style: GoogleFonts.poppins(
      textStyle: TextStyle(color: Colors.indigo[900], fontSize: MediaQuery
          .of(context)
          .size
          .width * 0.07), fontWeight: FontWeight.w600)),),
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(d2*0.12,d1*0.2,d2*0.12,d1*0.3),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Lottie.asset("assets/animation2.json",),
              SizedBox(height:d1*0.15),
              TextFormField(

                cursorColor: Colors.blue,
                controller: phoneController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  setState(() {
                    phoneController.text = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  //hintText: "Enter phone number",

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
                  hintText: "Phone Number",
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                              bottomSheetHeight: 550,
                            ),
                            onSelect: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            });
                      },
                      child: Text(
                        "${selectedCountry.flagEmoji}${selectedCountry.phoneCode}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: phoneController.text.length > 9
                      ? Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                String phonenumber = phoneController.text.trim();
                _auth.verifyPhoneNumber(

                    phoneNumber: ("${selectedCountry.phoneCode}$phonenumber"),
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
        ),
      ),
    );
  }
}
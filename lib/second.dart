import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';
import 'upload.dart';

class second extends StatefulWidget {

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {


  GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  TextEditingController title = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  var options = [
    'PDF',
    'Image',
    'video',
  ];
  bool value = false;
  var _currentItemSelected = "PDF";

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('folders')
        .snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(

          elevation: 0.0,
           centerTitle: true,

          actions: [
            IconButton(
              onPressed: () {
                _googleSignIn.signOut().then((value) {
                  setState(() {});
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (first()),
                    ),
                  );
                }).catchError((e) {});
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
          ],
          backgroundColor: Colors.blue[100],
          title:

              Text(
                'BigBucket',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.indigo[900], fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.07), fontWeight: FontWeight.w600)
              ),



        ),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return GestureDetector(

                      onTap: () {
                        print(
                          data['type'],
                        );
                        print(document.id);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (upload(

                              did: document.id,
                              type: data['type'],
                            )),
                          ),
                        );
                      },
                      child: ListTile(

                        leading: Icon(
                          Icons.folder,
                          color: Colors.amber[300],
                          size: 50,
                        ),
                        title: Text(data['name']),
                        subtitle: Text(data['type']),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            Positioned(
              bottom: 10,
              // left: 0,
              right: 10,
              child: Center(
                child: FloatingActionButton(
                  onPressed: () async {
                    await showInformationDialog(context);
                  },
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        bool isChecked = false;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: title,
                      validator: (value) {
                        // return value.isNotEmpty ? null : "Enter any text";
                      },
                      decoration: InputDecoration(hintText: "Please Enter name of Folder"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    DropdownButton<String>(
                      dropdownColor: Color.fromARGB(255, 147, 189, 253),
                      isDense: true,
                      isExpanded: false,
                      iconEnabledColor: Color.fromARGB(255, 47, 0, 255),
                      // focusColor: Color.fromARGB(255, 245, 245, 245),
                      items: options.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(
                            dropDownStringItem,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValueSelected) {
                        setState(() {
                          _currentItemSelected = newValueSelected!;
                          print(_currentItemSelected);
                        });
                      },
                      value: _currentItemSelected,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                )),
            title: Text('Upload Any'),
            actions: <Widget>[
              InkWell(
                child: Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                  // }
                },
              ),
              SizedBox(
                width: 40,
              ),
              InkWell(
                child: Text('Create'),
                onTap: () {
                  if (title.text != '') {
                    User? user = _auth.currentUser;
                    ref.doc(user!.uid).collection('folders').add({
                      'name': title.text,
                      'type': _currentItemSelected,
                    });
                    title.clear();
                    Navigator.of(context).pop();
                  }
                },
              ),
              SizedBox(
                width: 40,
              ),
            ],
          );
        });
      },
    );
  }
}

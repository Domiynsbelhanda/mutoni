import 'package:avataar_generator/generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../authentification.dart';
import 'home.dart';

class UserProfil extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserProfil();
  }
}

class _UserProfil extends State<UserProfil>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: user()
      ),
    );
  }

  Widget user(){
    CollectionReference datas = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: datas.doc(FirebaseAuth.instance.currentUser?.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            color: Colors.white,
            child : Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                child : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 2,
                      child: SvgPicture.string(getSvg(new Options())),
                    ),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        '${data['email']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0
                        ),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        '${data['name']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0
                        ),
                      ),
                    ),

                    SizedBox(height: 8.0),

                    GestureDetector(
      onTap: (){
        AuthenticationHelper()
          .signOut()
          .then((result) {
              if (result == null) {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home()));
              } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      result,
                      style: TextStyle(fontSize: 16),
                    ),
                  ));
              }
          });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Deconnexion',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    )
                  ],
                )
              ),
            ),
          );
        }

        return Text('Pas de riviere');
      },
    );
  }
  
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

 //SIGN UP METHOD
  Future signUp({String? email, String? password, String? name, String? image}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser?.uid).set({
        'name' : name,
        'email': email,
        'password': password, 
        'image': image
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
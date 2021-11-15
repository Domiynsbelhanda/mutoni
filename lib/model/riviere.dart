import 'package:cloud_firestore/cloud_firestore.dart';

class Riviere {
  String uid;
  String name;
  double latitude;
  double longitude;
  String description;
  String image;
  Timestamp timestamp;

  Riviere({
    required this.uid, required this.name, required this.latitude, 
    required this.longitude, required this.description, required this.image, required this.timestamp});
}
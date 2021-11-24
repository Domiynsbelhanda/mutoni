import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mutoni/global.dart';
import 'package:mutoni/maps.dart';
import 'package:mutoni/model/riviere.dart';
import 'package:http/http.dart' as http;
import 'package:mutoni/view/signup.dart';
import 'package:mutoni/view/userProfil.dart';
import 'package:mutoni/view/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with TickerProviderStateMixin{

  CollectionReference riviereCollection = FirebaseFirestore.instance.collection('Riviere');
  String uid = uuid.v1();

  String id = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // riviereCollection.doc(uid).set(
    //   {
    //     'uid' : uid,
    //   'name': 'Luano', 
    //   'latitude' :-122.0323,
    //   'longitude': 37.3430, 
    //   'description': 'Riviere de la ville de Lubumbashi, l\'une des plus anciennes', 
    //   'image': 'https://easterncongotribune.com/wp-content/uploads/2014/03/epulu_05.jpg', 
    //   'timestamp': Timestamp.now(),
    //   }
    //   )
    //       .then((value) => print("Riviere Added"))
    //       .catchError((error) => print("Failed to add riviere: $error"));
    //position();

  }

  Riviere riviere = Riviere(
    uid: 'uid', 
    name: 'name', 
    latitude: 10.0, 
    longitude: 20.0, 
    description: 'description', 
    image: 'image', 
    timestamp: Timestamp.now()
  );

  late TabController tabController;

  position() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    double lat1 = 37.343;
    double long1 = -122.0323;
    String link = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${lat},${long}&destinations=${lat1},${long1}&key=${API_KEY}';

    http.Response response = await http.get(Uri.parse(link));
    final data = json.decode(response.body);
    print('dominique et :  $data');
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 6,
        child: Builder(builder: (BuildContext context){
          final TabController tab = DefaultTabController.of(context)!;
          tabController = tab;
          return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: couleurPrimaire,
              tabs: [
                Tab(icon: Icon(
                  FontAwesomeIcons.igloo,
                )
                ),
                Tab(icon: Icon(
                  FontAwesomeIcons.heart,
                )
                ),
                Tab(icon: Icon(
                  FontAwesomeIcons.map,
                )
                ),
                Tab(icon: Icon(
                  FontAwesomeIcons.hourglass,
                )
                ),
                Tab(icon: Icon(
                  FontAwesomeIcons.user,
                )
                ),
                Tab(icon: Icon(
                  FontAwesomeIcons.bars,
                )
                ),
              ],
            ),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/Mutoni.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: (){},
                            child: Icon(
                              FontAwesomeIcons.search,
                              color: Colors.black,
                            ),
                          )
                        ),

                        SizedBox(width: 16.0),

                        Container(
                          child: GestureDetector(
                            onTap: (){},
                            child: Icon(
                              FontAwesomeIcons.bell,
                              color: Colors.redAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              id == '' ? homeRiviere() : description(),
              auth.currentUser == null ? WelcomePage() : homeRiviere(),
              MapSample(riviere),
              homeRiviere(),
              auth.currentUser == null ? WelcomePage() : UserProfil(),
              homeRiviere(),
            ],
          ),
        );
        })
      ),
    );
  }

  Widget homeRiviere(){
    final Stream<QuerySnapshot> _rivStream = FirebaseFirestore.instance.collection('Riviere').snapshots();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _rivStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("En cours de chargement");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      id = document.id;
                    });
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(data['image']),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                          SizedBox(height: 4.0),
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                Text(
                                  'A 20 M',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  'Lat : ${data['latitude']} - Long : ${data['longitude']}',
                                  style: TextStyle(
                                    color: Colors.redAccent
                                  ),
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget description(){
    CollectionReference datas = FirebaseFirestore.instance.collection('Riviere');

    return FutureBuilder<DocumentSnapshot>(
      future: datas.doc(id).get(),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.cover
                        )
                      ),
                    ),

                    SizedBox(height: 4.0),
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0
                                  ),
                                ),

                                Text(
                                  'A 20 M',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  'Lat : ${data['latitude']} - Long : ${data['longitude']}',
                                  style: TextStyle(
                                    color: Colors.redAccent
                                  ),
                                )
                              ],
                            )
                          ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        '${data['description']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0
                        ),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: EdgeInsets.only(left: 32, right: 32),
                      child: GestureDetector(
                        onTap: (){
                          Riviere rivier = Riviere(
                            uid: snapshot.data!.id, 
                            name: data['name'], 
                            latitude: data['latitude'], 
                            longitude: data['longitude'], 
                            description: data['description'], 
                            image: data['image'], 
                            timestamp: data['timestamp']);

                          setState(() {
                            riviere = rivier;
                            tabController.animateTo(2);
                          });
                        },
                        child: Container(
                          child: Text(
                            'Voir sur google Maps',
                            style: TextStyle(
                              color: Colors.blue
                            )
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: EdgeInsets.only(left: 32, right: 32),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            id = '';
                          });
                        },
                        child: Container(
                          child: Text(
                            'Go To Home',
                            style: TextStyle(
                              color: Colors.black
                            )
                          ),
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
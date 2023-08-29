import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Position currentPosition;
  String currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  getCurrentLocation() {
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position){
      setState(() {
        currentPosition = position;
      });
      getAddressFromLatLng();
    }).catchError((e){
      print(e);
    });
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    getCurrentLocation();
    getAddressFromLatLng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Geolocation App",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      drawer: new Drawer(),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text("Location :",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
          new Padding(padding: const EdgeInsets.only(top: 10)),
          new Card(
            color: Colors.grey[800],
            elevation: 10,
            shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: new Container(
              padding: const EdgeInsets.all(5),
              child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(Icons.location_on,size: 30,color: Colors.white,),
              currentPosition == null ? Text("Please Wait") : new Text("LAT: ${currentPosition.latitude}, LNG: ${currentPosition.longitude}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
            ],
          ),
        )
        ),
          new Padding(padding: const EdgeInsets.only(top: 10)),
          new Card(
            color: Colors.grey[800],
            elevation: 10,
            shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: new Container(
              padding: const EdgeInsets.all(5),
              child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(Icons.location_on,size: 30,color: Colors.white,),
              currentAddress == null ? Text("Please Wait") : new Text(currentAddress,style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
            ],
          ),
        )
        )
        ],
      ),
    );
  }
}
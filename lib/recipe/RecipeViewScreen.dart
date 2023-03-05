import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class RecipeViewScreen extends StatefulWidget {
  static const String idScreen = "RecipeViewScreen";

  final String title,description,ingredients;
  RecipeViewScreen({required this.title,required this.description,required this.ingredients}): super();

  @override
  _hotelViewScreen createState() => _hotelViewScreen();
}

class _hotelViewScreen extends State<RecipeViewScreen> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String name = "", email = "", imgUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialise();
  }

  initialise() {
    setState(() {
      name = storage.getItem('name');
      email = storage.getItem('email');
      imgUrl = storage.getItem('pic');
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(
                      0.0,
                      10.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: -6.0,
                  ),
                ],
              )
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: "Brand Bold",
                      color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  widget.ingredients,
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                )
              ]))
        ],
      ),
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text("Hotel View"),
        ),
        backgroundColor: Colors.white,
        body: new Container(child: body));
  }
}

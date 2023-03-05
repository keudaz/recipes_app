import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';

class RecipeScreen extends StatefulWidget {
  static const String idScreen = "RecipeScreen";

  @override
  _RecipeScreen createState() => _RecipeScreen();
}

class _RecipeScreen extends State<RecipeScreen> {
  bool _loading = false;
  final LocalStorage storage = new LocalStorage('localstorage_app');

  String name = "", email = "", imgUrl = "";

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController ingredientsTextEditingController = TextEditingController();
  
  var textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialise();
  }

  initialise() {
    setState(() {
      imgUrl = storage.getItem("pic");
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = new SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 35.0,
            ),
            Image(
              image: AssetImage("images/logo.png"),
              width: 150.0,
              height: 150.0,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 1.0,
            ),
            Text(
              "Add New Recipe",
              style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 1.0,
                  ),
                  TextField(
                    controller: titleTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Recipe Title",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: descriptionTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  TextField(
                    controller: ingredientsTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Ingredients",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    child: Container(
                      height: 50.0 ,
                      child: Center(
                        child: Text(
                          "Insert Data",
                          style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold" ,color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: ()
                    {
                      if (titleTextEditingController.text.isEmpty) {
                        displayToastMessage("title is Required", context);
                      } else if (descriptionTextEditingController.text.isEmpty) {
                        displayToastMessage("Address is Required!", context);
                      } else if (ingredientsTextEditingController.text.isEmpty) {
                        displayToastMessage("Province is Required!", context);
                      } else {
                        insertData(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Plase Wait...",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Recipe"),
        ),
        backgroundColor: Colors.white,
        body: new Container(child: _loading ? bodyProgress : body));
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void insertData(BuildContext context) async {
    try {
      await FirebaseDatabase.instance.reference().child("recipe").set({
        'title': titleTextEditingController.text,
        'description': descriptionTextEditingController.text,
        'ingredients': ingredientsTextEditingController.text,
        'userid': storage.getItem("userid")
      }).then((value) =>
      {
        titleTextEditingController.text="",
        descriptionTextEditingController.text="",
        ingredientsTextEditingController.text="",
        setState(() {
          _loading = false;
        })
      });
    } catch (e) {
      print(e);
    }

    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: 'Data Insert Successful!',
    );
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

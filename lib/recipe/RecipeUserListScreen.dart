import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'RecipeViewScreen.dart';

class RecipeUserListScreen extends StatefulWidget {
  static const String idScreen = "RecipeUserListScreen";

  @override
  _RecipeUserListScreen createState() => _RecipeUserListScreen();
}

class _RecipeUserListScreen extends State<RecipeUserListScreen> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  List docs = [],all_docs = [];

  String name = "", email = "", imgUrl = "";

  Future<List?> hotelsList() async {
    DataSnapshot snapshot;
    List list = [];
    try {
      snapshot = await FirebaseDatabase.instance.ref("recipe").get();

      Map recipe = snapshot.value as Map;
      recipe.forEach((key, value) {
        print(recipe);
          Map map = {
            "title": value['title'],
            "description": value['description'],
            "ingredients": value['ingredients'],
            "id": value.id
          };
          list.add(map);
      });

      return list;
    } catch (e) {
      print(e);
    }
  }

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
    this.hotelsList().then(
      (value) => {
        setState(() {
          docs = value!;
          all_docs = value;
        })
    });
  }

  void filterSearchResults(String query) {
    List temp_list=[];
    if(query.isNotEmpty) {
      for (var temp in all_docs) {
        if (temp['title'].contains(query)||temp['description'].contains(query)||temp['ingredients'].contains(query)){
          temp_list.add(temp);
        }
      }
      setState(() {
        docs = temp_list;
      });
    }else{
      setState(() {
        docs = all_docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = Container(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          onChanged: (value) {
            filterSearchResults(value);
          },
          controller: searchController,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  filterSearchResults("");
                  searchController.text="";
                },
              ),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue,
                    width: 5.0),
              )
          ),
        )
      ),
      Expanded(
          child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeViewScreen(
                                  title: docs[index]['title'],
                                  description: docs[index]['description'],
                                  ingredients: docs[index]['ingredients'],
                            )));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                docs[index]['title'].toString(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Brand Bold",
                                    color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                docs[index]['description'].toString(),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                docs[index]['ingredients'].toString(),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                );
              }
            )
          )
        ]
      )
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe List"),
        ),
        backgroundColor: Colors.white,
        body: new Container(child: body));
  }
}

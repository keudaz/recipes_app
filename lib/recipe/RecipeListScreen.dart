import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'RecipeEditScreen.dart';
import 'RecipeViewScreen.dart';

class RecipeListScreen extends StatefulWidget {
  static const String idScreen = "RecipeListScreen";

  @override
  _RecipeListScreen createState() => _RecipeListScreen();
}

class _RecipeListScreen extends State<RecipeListScreen> {
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
        if (value['userid'].toString() ==storage.getItem("userid").toString()) {
          print(recipe);
          Map map = {
            "title": value['title'],
            "description": value['description'],
            "ingredients": value['ingredients'],
            "id": value.id
          };
          list.add(map);
        }
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
        if (temp['title'].contains(query)||temp['description'].contains(query)||temp['province'].contains(query)
            ||temp['ingredients'].contains(query)||temp['city'].contains(query)||temp['nearestTown'].contains(query)
            ||temp['email'].contains(query)||temp['phone'].contains(query)){
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

  // list refresh
  Future<void> _onRefresh() async {
    docs = [];
    await this.hotelsList().then((value) => {
          setState(() {
            docs = value!;
          })
        });
  }

  void delete_firestore(String id) {
    firestore.collection('hotels').doc(id).delete();
  }

  // delete function
  void delete(String id) async {
    // confirmation alert
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      text: 'Do you want to Delete?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () async {
        await Future.delayed(Duration(milliseconds: 1000));
        this.delete_firestore(id);
        Navigator.pop(context);
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: 'Successful',
          text: 'Delete Successful!',
          loopAnimation: false,
        );
        _onRefresh();
      },
    );
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
                                  ingredients: docs[index]['ingredients']
                            )));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                offset: Offset(
                                  0.0,
                                  10.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: -6.0,
                              ),
                            ],
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.multiply,
                              ),
                              image:
                                  NetworkImage(docs[index]['pic'].toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
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
                                docs[index]['description'].toString() +
                                    "," +
                                    docs[index]['province'].toString() +
                                    "," +
                                    docs[index]['ingredients'].toString() +
                                    "," +
                                    docs[index]['city'].toString() +
                                    ", Nearest Town: " +
                                    docs[index]['nearestTown'].toString() +
                                    ".",
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
                                docs[index]['dis'].toString(),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                docs[index]['phone'].toString(),
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                docs[index]['email'].toString(),
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                              Align(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              SizedBox(width: 5),
                                              Text("Edit",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RecipeEditScreen(
                                                        id: docs[index]['id'],
                                                        title: docs[index]
                                                            ['title'],
                                                        description: docs[index]
                                                            ['description'],
                                                      ingredients: docs[index]
                                                      ['ingredients'],
                                              )));
                                        }),
                                    GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              SizedBox(width: 5),
                                              Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          this.delete(
                                              docs[index]['id'].toString());
                                        })
                                  ],
                                ),
                                alignment: Alignment.bottomLeft,
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

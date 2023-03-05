import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:recipes_app/Screens/loginScreen.dart';
import 'package:recipes_app/recipe/RecipeListScreen.dart';
import '../Drawer/Drawer.dart';
import '../recipe/RecipeScreen.dart';
import '../recipe/RecipeUserListScreen.dart';

class UserDashboard extends StatefulWidget {
  static const String idScreen = "UserDashboard";

  @override
  _UserDashboard createState() => _UserDashboard();
}

class _UserDashboard extends State<UserDashboard> {
  final LocalStorage storage = new LocalStorage('localstorage_app');

  String name="",email="",imgUrl="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialise();
  }

  initialise() {
    setState(() {
      name=storage.getItem('name');
      email=storage.getItem('email');
      imgUrl=storage.getItem('pic');
    });
  }

  void logout(context) async {

    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      text: 'Do you want to Logout?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () async {
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
        storage.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.idScreen, (route) => false);
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(name:name,email:email,imgUrl:imgUrl),
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 250.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 10.0,),
              Text(
                "Recipe App",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 30.0,),
                    ElevatedButton(
                      child: Container(
                        height: 50.0 ,
                        child: Center(
                          child: Text(
                            "Add Recipe's",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold" ,color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: ()
                      {

                        Navigator.pushNamedAndRemoveUntil(context, RecipeScreen.idScreen, (route) => true);

                      },
                    ),

                    SizedBox(height: 30.0,),
                    ElevatedButton(
                      child: Container(
                        height: 50.0 ,
                        child: Center(
                          child: Text(
                            "My Recipe's",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold" ,color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: ()
                      {

                        Navigator.pushNamedAndRemoveUntil(context, RecipeListScreen.idScreen, (route) => true);

                      },
                    ),

                    SizedBox(height: 30.0,),
                    ElevatedButton(
                      child: Container(
                        height: 50.0 ,
                        child: Center(
                          child: Text(
                            "All Recipe's",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold" ,color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: ()
                      {

                        Navigator.pushNamedAndRemoveUntil(context, RecipeUserListScreen.idScreen, (route) => true);

                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

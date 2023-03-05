import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:recipes_app/Screens/loginScreen.dart';
import 'package:recipes_app/Screens/userDashboard.dart';

class WelcomeScreen extends StatefulWidget {
  static const String idScreen = "welcomeScreen";

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {

  final LocalStorage storage = new LocalStorage('localstorage_app');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    navigateScreen(context);
    return Scaffold(
      appBar: AppBar(
      title: Text("Welcome"),
    ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
              child: Center(
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
                "Welcome",
                style: TextStyle(fontSize: 30.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0,),
              Text(
                "Recipe App",
                style: TextStyle(fontSize: 35.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100.0,),
              SizedBox(
                child: CircularProgressIndicator(),
                height: 50.0,
                width: 50.0,
              ),
            ],
            ),
        ),
      ),
    );
  }

  void navigateScreen(context)
  {
    var d = Duration(seconds: 3);
    // delayed 3 seconds to next page
    Future.delayed(d, () {
      // to next page and close this page
      if(storage.getItem('name')!=null){
        if(storage.getItem('userType').toString()!="admin"){
          Navigator.pushNamedAndRemoveUntil(context, UserDashboard.idScreen, (route) => false);
        }else{
          Navigator.pushNamedAndRemoveUntil(context, UserDashboard.idScreen, (route) => false);
        }
      }else{
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
      }
    });
  }
}
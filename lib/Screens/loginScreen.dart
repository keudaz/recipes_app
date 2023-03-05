import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/Screens/registerationScreen.dart';
import 'package:recipes_app/Screens/userDashboard.dart';

class LoginScreen extends StatelessWidget 
{
  static const String idScreen = "login";
  final LocalStorage storage = new LocalStorage('localstorage_app');

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Login"),
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
                  SizedBox(height: 10.0,),
                  TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  hintStyle: TextStyle (
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                ),
                style: TextStyle(fontSize: 14.0),
              ),

                  SizedBox(height: 10.0,),
                  TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,  
                  decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  hintStyle: TextStyle (
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                ),
                style: TextStyle(fontSize: 14.0),
              ),

                SizedBox(height: 30.0,),
                ElevatedButton(
                  child: Container(
                    height: 50.0 ,
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold" ,color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: ()
                  {

                    if(!emailTextEditingController.text.contains("@"))
                    {
                      displayToastMessage("Email address is not valid", context);
                    }
                    else if(passwordTextEditingController.text.isEmpty)
                    {
                      displayToastMessage("Password is mandatory.", context);
                    }
                    else
                    {
                      loginAndAuthenticateUser(context);
                    }
                    
                  },
                ),

                  ],
                ),
                ),

              TextButton(
                  onPressed: ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => true);
                  },
                  child: Text(
                    "Do not have an Account? Register Here.",
                  ),
                ),
            ],
            ),
        ),
      ),
    );
  }

   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   void loginAndAuthenticateUser(BuildContext context) async
   {
     showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context)
         {
           return LoginScreen();
         }
     );

     final User? firebaseUser = (await _firebaseAuth
         .signInWithEmailAndPassword(
         email: emailTextEditingController.text,
         password: passwordTextEditingController.text
     ).catchError((errMsg){
       Navigator.pop(context);
       displayToastMessage("Error: " + errMsg.toString() , context);
     }
     )).user;

     if(firebaseUser != null)  //user created
         {

       storage.setItem('userid', firebaseUser.uid);
       print(firebaseUser.uid);

       try{
         final dbRef = FirebaseDatabase.instance.ref("users").child(firebaseUser.uid);
         DataSnapshot snapshot = await dbRef.get();

         Map user = snapshot.value as Map;
         storage.setItem('email', user["email"].toString());
         storage.setItem('name', user["name"].toString());
         storage.setItem('pic', user["pic"].toString());
         Navigator.pushNamedAndRemoveUntil(context, UserDashboard.idScreen, (route) => false);
         displayToastMessage("Welcome", context);

       }catch (e){
         print(e);
       }

     }
     else
     {
       Navigator.pop(context);
       displayToastMessage("Error Occured, can not.", context);
     }

   }

}
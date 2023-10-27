import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petapp/Views/auth/login_signup.dart';

class accchoicescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF818AF9), // Set the background color here
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15), // Add horizontal padding
              child: Text(
                "Create an account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15
              ),
              child: MaterialButton(
                height: 40, // Set the height to make the button smaller
                minWidth: 150,
                color: Colors.orange,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // You can adjust the radius as needed
                ),



                onPressed: (){
                  Get.to(()=> LoginView());
                },
                child: Text("As a pet owner ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15
              ),
              child: MaterialButton(
                height: 40, // Set the height to make the button smaller
                minWidth: 150,
                color: Colors.orange,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // You can adjust the radius as needed
                ),



                onPressed: (){
                  Get.to(()=> LoginView());
                },
                child: Text("As a Trainer",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Image.asset('assets/Picture1.png'),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

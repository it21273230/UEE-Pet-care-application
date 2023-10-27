import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/Views/auth/login_signup.dart';
import 'package:petapp/Views/choicescreen.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF818AF9), // Set the background color here
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15), // Add horizontal padding
            child: Text(
              "Helping you to keep your bestie stay healthy!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: MaterialButton(
              height: 40,
              minWidth: 150,
              color: Colors.orange,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                Get.to(() => choicescreen()); // Create an instance of choicescreen
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 90,
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
    );
  }
}

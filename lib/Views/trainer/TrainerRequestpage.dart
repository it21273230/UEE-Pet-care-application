import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../model/message_model.dart';
import '../../services/notification_service.dart';
import '../trainer/TrainerPage.dart';


class TrainerRequestsScreen extends StatefulWidget {
  @override
  _requestsScreenState createState() => _requestsScreenState();
}

class _requestsScreenState extends State<TrainerRequestsScreen> {


  DataController dataController = Get.find<DataController>();


  String myUid = FirebaseAuth.instance.currentUser!.uid;

  Future sendEmail({
  required String name,
    required String email,
    required String subject,
    required String message,

}) async{
    final serviceId = 'service_n7epb1p';
    final templateId = 'template_74hs2ky';
    final userId = 'UZ0CJTKC5SDmywSAk';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
        url,
         headers: {
          'origin': 'http://localhost',
          'Content-Type' : 'application/json',
         },
         body: json.encode({
          'service_id':serviceId,
           'template_id':templateId,
           'user_id': userId,
           'template_params' : {
            'user_name':name,
             'user_email':email,
             'user_message':message,
             'user_subject':subject,
           }
         }));
    print(response.body);

  }

  @override
  Widget build(BuildContext context) {

    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Trainer Requests",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: screenheight * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [

                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(()=> ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: dataController.filteredtrainersrequests.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {


                        String TrainerName = '' , requester_name = ''   , CurrentUser = ''  ,requester_token = '';
                        try{
                          TrainerName = dataController.filteredtrainersrequests[index].get('TrainerName');

                        }catch(e){
                          TrainerName = '';
                        }
                        try{

                          CurrentUser =dataController!.myDocument!.get('first') + ' '+ dataController!.myDocument!.get('last');
                        }catch(e){
                          CurrentUser = '';
                        }

                        try{
                          requester_name = dataController.filteredtrainersrequests[index].get('requestername');
                        }catch(e){
                          requester_name = '';
                        }
                        try{
                          requester_token = dataController.filteredtrainersrequests[index].get('requesterToken');
                        }catch(e){
                          requester_token = '';
                        }


                        return TrainerName != CurrentUser? Container() : InkWell(

                          child: GestureDetector(

                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              width: screenwidth * 0.3,   // Adjust the width to your desired size
                              height: screenheight * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [

                                  SizedBox(
                                    width: screenwidth * 0.06,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: screenheight * 0.002,
                                        ),
                                        Text(
                                          requester_name + " Requested to hire you",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: screenheight * 0.004,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 15, right: 7.5),
                                                child: MaterialButton(
                                                  height: 30,
                                                  color: Colors.green,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  onPressed: () {
                                                    Get.snackbar('You accept', requester_name,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors.blue);

                                                    dataController!.createNotification(requester_name!);
                                                    LocalNotificationService.sendNotification(
                                                        title: 'New message',
                                                        message: "You were accepted by " + TrainerName,
                                                        token: requester_token);

                                                    sendEmail(
                                                        name: 'Tharuka',
                                                        email: 'it21263194@my.sliit.lk',
                                                        subject: 'Go f your self',
                                                        message: 'Uba modai');
                                                  },
                                                  child: Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 7.5, right: 15),
                                                child: MaterialButton(
                                                  height: 30,
                                                  color: Colors.red,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  onPressed: () {
                                                    Get.snackbar('You deny', requester_name,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors.red);

                                                    dataController!.createNotification(requester_name!);
                                                    LocalNotificationService.sendNotification(
                                                        title: 'New message',
                                                        message: "You were denied by " + TrainerName,
                                                        token: requester_token);
                                                  },
                                                  child: Text(
                                                    "Deny",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: screenheight * 0.001,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Text(''),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenwidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

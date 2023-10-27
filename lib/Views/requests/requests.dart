import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../model/message_model.dart';
import '../../services/notification_service.dart';
import '../trainer/TrainerPage.dart';
import 'package:http/http.dart' as http;

class RequestsScreen extends StatefulWidget {
  @override
  _requestsScreenState createState() => _requestsScreenState();
}

class _requestsScreenState extends State<RequestsScreen> {


  DataController dataController = Get.find<DataController>();


  String myUid = FirebaseAuth.instance.currentUser!.uid;

  Future sendEmail({
    required String name,
    required String senderemail,

    required String organizer_email,
    required String organizer_name,

  }) async{
    final serviceId = 'service_n7epb1p';
    final templateId = 'template_q55nq2k';
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
            'user':senderemail,
            'organizer':organizer_email,
            'organizer_name':organizer_name,
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
                    "My Requests",
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
                      itemCount: dataController.filterdrequests.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {


                        String Organizername = '', event_id = '' , requester_name = '' , desc = '' , certificate = '' , fullname = ''  ,requester_id = '' , requester_email = '';
                        try{
                          Organizername = dataController.filterdrequests[index].get('organizerName');

                        }catch(e){
                          Organizername = '';
                        }
                        try{

                          fullname =dataController!.myDocument!.get('first') + ' '+ dataController!.myDocument!.get('last');
                        }catch(e){
                          fullname = '';
                        }
                        try{
                          event_id = dataController.filterdrequests[index].get('eventId');
                        }catch(e){
                          event_id = '';
                        }
                        try{
                          requester_name = dataController.filterdrequests[index].get('requestername');
                        }catch(e){
                          requester_name = '';
                        }
                        try{
                          requester_email = dataController.filterdrequests[index].get('requester_email');
                        }catch(e){
                          requester_email = '';
                        }
                        try{
                          requester_id = dataController.filterdrequests[index].get('requesterUid');
                        }catch(e){
                          requester_id = '';
                        }


                        return Organizername != fullname? Container() : InkWell(

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
                                          requester_name + " Requested to join your event",
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
                                                  minWidth: 150,
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
                                                        message: "You were accepted by " + Organizername,
                                                        token: requester_id);

                                                    sendEmail(name: requester_name, senderemail: requester_email, organizer_email: Organizername, organizer_name: Organizername);
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
                                                  minWidth: 150,
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
                                                        message: "You were denied by " + Organizername,
                                                        token: requester_id);
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

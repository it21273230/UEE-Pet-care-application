import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../model/message_model.dart';
import '../trainer/TrainerPage.dart';


class TrainerScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<TrainerScreen> {


  DataController dataController = Get.find<DataController>();


  String myUid = FirebaseAuth.instance.currentUser!.uid;

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
                    "Trainers",
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
                    Container(
                      height: screenheight * 0.09,
                      width: screenwidth * 0.9,
                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        onChanged: (String input){
                          if(input.isEmpty){
                            dataController.filteredtrainers.assignAll(dataController.alltrainers);
                          }else{
                           List<DocumentSnapshot> users =  dataController.alltrainers.value.where((element) {
                        String name;
                               try{
                        name = element.get('first') + ' '+ element.get('last');
                      }catch(e){
                        name = '';
                      }


                              return name.toLowerCase().contains(input.toLowerCase());
                            }).toList();



                          dataController.filteredtrainers.value.assignAll(users);
                          setState(() {
                            
                          });
                          

                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 0, height: 0),
                          focusedErrorBorder: InputBorder.none,
                          fillColor: Colors.deepOrangeAccent[2],
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          hintStyle:
                          TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Obx(()=> ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: dataController.filteredtrainers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {


                      String name = '', image = '' ,experience = '' , cost = '' , desc = '' , certificate = '';
                      try{
                        name = dataController.filteredtrainers[index].get('first') + ' '+ dataController.filteredtrainers[index].get('last');
                      }catch(e){
                        name = '';
                      }

                      try{
                        image = dataController.filteredtrainers[index].get('image');
                      }catch(e){
                        image = '';
                      }
                      try{
                        experience = dataController.filteredtrainers[index].get('experience');
                      }catch(e){
                        experience = '';
                      }
                      try{
                        cost = dataController.filteredtrainers[index].get('cost');
                      }catch(e){
                        cost = '';
                      }
                      try{
                        desc = dataController.filteredtrainers[index].get('desc');
                      }catch(e){
                        desc = '';
                      }
                      try{
                        certificate = dataController.filteredtrainers[index].get('certificate');
                      }catch(e){
                        certificate = '';
                      }


                      String fcmToken = '';
                       try{
                        fcmToken = dataController.filteredtrainers[index].get('fcmToken');
                      }catch(e){
                        fcmToken = '';
                      }







                      return dataController.filteredtrainers[index].id == FirebaseAuth.instance.currentUser!.uid? Container() : InkWell(
                        onTap: () {

                          String chatRoomId = '';
                          if(myUid.hashCode>dataController.filteredtrainers[index].id.hashCode){
                            chatRoomId = '$myUid-${dataController.filteredtrainers[index].id}';
                          }else{
                            chatRoomId = '${dataController.filteredtrainers[index].id}-$myUid';
                          }

                          Get.to(() => TrainerPage(name: name,image: image,experience:experience,cost : cost , desc :desc ,certificate : certificate, uid: dataController.filteredUsers[index].id,));
                        },
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
                                Container(
                                  width: 140,  // Adjust the width to your desired size
                                  height: 140, // Adjust the height to your desired size
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24), // Set the corner radius to 24
                                    color: Colors.white, // Or any other background color you want
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.network(
                                      image,
                                      width: 140, // Adjust the width to your desired size
                                      height: 140, // Adjust the height to your desired size
                                      fit: BoxFit.cover, // To make the image cover the entire square
                                    ),
                                  ),
                                ),
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
                                        name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: screenheight * 0.004,
                                      ),
                                      Text(
                                        experience,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
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

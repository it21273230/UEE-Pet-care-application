import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';



import '../Views/bottom_nav_bar/BottombarTrainer.dart';
import '../Views/bottom_nav_bar/bottom_bar_view.dart';

import '../Views/create_profile_trainer.dart';
import '../Views/create_profile.dart';

import '../Views/trainer/TrainerRequestpage.dart';


class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  void login({String? email, String? password}) {
    isLoading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      /// Login Success

      isLoading(false);
      Get.to(() => BottomBarView());
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occured
    });
  }
  void loginTrainer({String? email, String? password}) {
    isLoading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      /// Login Success

      isLoading(false);
      Get.to(() => BottomBarTrainerView());
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occured
    });
  }



  void signUp({String? email, String? password}) {
    isLoading(true);
    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {

      isLoading(false);
      /// Navigate user to profile screen
      Get.to(() => ProfileScreen());
    }).catchError((e) {
      isLoading(false);
      /// print error information
      print("Error in authentication $e");

    });
  }
  void signUpTrainer({String? email, String? password}) {
    isLoading(true);
    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {

      isLoading(false);
      /// Navigate user to profile screen
      Get.to(() => ProfileScreenTrainer());
    }).catchError((e) {
      isLoading(false);
      /// print error information
      print("Error in authentication $e");

    });
  }

  var isProfileInformationLoading = false.obs;

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
    FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error happen $e");
    });

    return imageUrl;
  }
  uploadProfileData(String imageUrl, String firstName, String lastName, String breed,
      String mobileNumber, String dob, String gender) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'first': firstName,
      'last': lastName,
      'cost':null,
      'breed':breed,
      'dob': dob,
      'isTrainer':'nottrainer',
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(()=> BottomBarView());
    });

  }
  uploadProfileDataTrainer(String imageUrl, String firstName, String lastName, String cost, String certificate,String experience,
      String mobileNumber, String dob, String gender) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'first': firstName,
      'last': lastName,
      'cost':cost,
      'certificate':certificate,
      'experience':experience,
      'dob': dob,
      'isTrainer':'trainer',
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(()=> BottomBarView());
    });

  }


}

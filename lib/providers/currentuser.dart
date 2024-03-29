import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CurrentUser with ChangeNotifier{
  
  FirebaseUser user;
  DocumentSnapshot userData;
  DocumentSnapshot userDataByID;

  Future<void> fetchUserData() async {
    user=await FirebaseAuth.instance.currentUser();
    userData=await Firestore.instance.collection('users').document(user.uid).get();

    notifyListeners();
  }

  FirebaseUser get curruser {
    return user;
  }

  DocumentSnapshot get userdata{
    return userData;
  }
  DocumentSnapshot get userdatabyid{
    return userDataByID;
  }

  Future<void> fetchUserDataById(String uid) async {
    userDataByID=await Firestore.instance.collection('users').document(uid).get();

    notifyListeners();
  }

}
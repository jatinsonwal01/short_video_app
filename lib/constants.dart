import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sasta_tiktok/controllers/auth_controller.dart';
import 'package:sasta_tiktok/views/screens/add_video_screen.dart';
import 'package:sasta_tiktok/views/screens/profile_screen.dart';
import 'package:sasta_tiktok/views/screens/search_screen.dart';
import 'package:sasta_tiktok/views/screens/video_screen.dart';

//pages
List pages=[
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const Center(child: Text('messages Screen'),),
  ProfileScreen(uid: authController.user.uid),

];

//COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// firebase
var firebaseAuth= FirebaseAuth.instance;
var firebaseStorage= FirebaseStorage.instance;
var fireStore= FirebaseFirestore.instance;

// controllers

var authController=AuthController.instance;
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/user_data_service.dart';
import '../../models/user_data_model.dart';
import '../home_screen/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic userData1;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    getData();
  }


  late final Map<String, dynamic> responseData;
  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    responseData = prefs.getStringList('user') as Map<String, dynamic>;

    print("User Values....");
    // print(user.toString());


  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
          child: isLoading
              ? CupertinoActivityIndicator(

            radius: 15,

          ) // iOS style loader
              : userData1 !=null ? Text(userData1) : Text('Loading...')
      ),
    );
  }
}

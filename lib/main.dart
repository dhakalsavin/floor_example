import 'dart:async';
import 'package:floor_example/database.dart';
import 'package:floor_example/homepage.dart';
import 'package:floor_example/post_dao.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'post.dart';
import 'details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('test.db').build();
  final dao = database.postDao;
  runApp(MyApp(dao));
}

class MyApp extends StatelessWidget {
  final PostDao dao;

  const MyApp(this.dao);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        dao: dao,
      ),
    );
  }
}

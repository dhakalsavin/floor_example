import 'dart:async';
import 'package:floor_example/post_dao.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'database.dart';
import 'post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  final dao = database.postDao;
  runApp(MyApp(dao));
}

class Data {
  final int id;
  final String title;

  Data({
    required this.id,
    required this.title,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
    );
  }
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

class MyHomePage extends StatelessWidget {
  final PostDao dao;
  MyHomePage({super.key, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView'),
      ),
      body: RefreshIndicator(
        onRefresh: () => checkConnectivity(),
        child: FutureBuilder(
          future: checkConnectivity(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data![index].id.toString()),
                                Text(snapshot.data![index].title),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('Unexpected error occurred!');
                  }
                },
              );
            } else {
              return FutureBuilder(
                future: dao.findAllPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data![index].id.toString()),
                                Text(snapshot.data![index].title),
                                Text('qq')
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('Unexpected error occurred!');
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Data>> fetchData() async {
    final List<Post> posts = [];
    List jsonData;
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
    // final dao = database.postDao;

    final dio = Dio();
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/posts');

    jsonData = response.data;
    for (var item in jsonData) {
      final post = Post(item['id'], item['title']);
      posts.add(post);
    }
    dao.insertPost(posts);
    return jsonData.map((e) => Data.fromJson(e)).toList();
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}

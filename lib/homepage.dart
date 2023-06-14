import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:floor_example/post.dart';
import 'package:floor_example/post_dao.dart';
import 'package:flutter/material.dart';

import 'details_screen.dart';

class MyHomePage extends StatelessWidget {
  final PostDao dao;
  const MyHomePage({super.key, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final product = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(dao: dao, id: product.id)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white10,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                snapshot.data![index].id.toString(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(snapshot.data![index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 25, color: Colors.black)),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Data>> fetchData() async {
    final List<Data> posts = [];
    List jsonData;
    if (await checkConnectivity()) {
      final dio = Dio();
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');

      jsonData = response.data;
      for (var item in jsonData) {
        // final post = Post(item['id'], item['title']);
        final data = Data.fromJson(item);
        posts.add(data);
      }
      dao.insertPost(posts);

      return jsonData.map((e) => Data.fromJson(e)).toList();
    } else {
      return dao.findAllPost();
    }
  }
}

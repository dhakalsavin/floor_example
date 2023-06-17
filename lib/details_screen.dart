import 'package:floor_example/post.dart';
import 'package:floor_example/post_dao.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final PostDao dao;
  final int id;
  const DetailsScreen({super.key, required this.dao, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Future<Data?>? _data;
  @override
  initState() {
    super.initState();
    _data = widget.dao.findAllPostId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("DetailsScreen"),
        ),
        body: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(snapshot.data!.id.toString()))),
                      const Text(
                        'Post',
                        style: TextStyle(fontSize: 25, color: Colors.black54),
                      ),
                      Text(
                        snapshot.data!.title,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Image.network(snapshot.data!.url)
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}

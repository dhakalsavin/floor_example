// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:floor/floor.dart';
import 'package:floor_example/post.dart';
import 'package:floor_example/post_controller.dart';
import 'package:floor_example/post_dao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'details_screen.dart';

class MyHomePage extends StatefulWidget {
  final PostDao dao;
  MyHomePage({super.key, required this.dao});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();
  List<Data>? _dataList;
  Future<void>? _initPostData;

  final postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    _initPostData = _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Obx(() => FutureBuilder<dynamic>(
                future: postController.checkConnectivity(),
                builder: (context, snapshot) {
                  print('alll${snapshot.data}');
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Text('Offline');
                  } else {
                    bool isConnected = snapshot.data as bool;
                    return isConnected
                        ? const Text('Online')
                        : const Text('Offline');
                  }
                },
              ))),
      body: FutureBuilder(
        future: _initPostData,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                return const Center(
                  child: Text('Loading...'),
                );
              }
            case ConnectionState.done:
              {
                return RefreshIndicator(
                    // key: _refreshIndicatorKey,
                    onRefresh: _refreshData,
                    child: ListView.builder(
                        itemCount: _dataList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_dataList![index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 25, color: Colors.blue)),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: _dataList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final product = _dataList![index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsScreen(
                                                            dao: widget.dao,
                                                            id: product.id)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white10,
                                              ),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/download.jpeg',
                                                    scale: 5,
                                                  ),
                                                  Text(
                                                    _dataList![index]
                                                        .id
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        _dataList![index].title,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  const Icon(
                                                      Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 0.5,
                                )
                              ],
                            ),
                          );
                        }));
              }
          }
        },
      ),
    );
  }

  Future<void> _initData() async {
    final posts = await postController.fetchAndMergeData(widget.dao);
    _dataList = posts;
  }

  Future<void> _refreshData() async {
    final posts = await postController.fetchAndMergeData(widget.dao);
    setState(() {
      _dataList = posts;
    });
  }
}

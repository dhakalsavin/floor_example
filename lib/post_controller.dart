import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:floor/floor.dart';
import 'package:floor_example/database.dart';
import 'package:floor_example/post.dart';
import 'package:floor_example/post_dao.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  RxBool connectivityResult = false.obs;

  checkConnectivity() async {
    print("aaaa${connectivityResult}");
    final result = await Connectivity().checkConnectivity();
    return connectivityResult.value = result != ConnectivityResult.none;
  }


  Future<List<Data>> fetchAndMergeData(PostDao dao) async {
  final List<Data1> data1 = await fetchDataFromAPI1();
  final List<Data2> data2 = await fetchDataFromAPI2();

  List<Data> combinedData = [];

   for (var d1 in data1) {
    final d2 = data2.firstWhere((element) => element.id == d1.id);
    combinedData.add(Data( title:d1.title, url:d2.url, id: d1.id,));
  }
   bool check = await checkConnectivity() as bool;
    if (check) {
      dao.deleteTable();
      dao.insertPost(combinedData);

      return combinedData;
    } else {
      return dao.findAllPost();
    }
}

Future<List<Data1>> fetchDataFromAPI1() async {
  try {
    final dio = Dio();
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts/?_limit=3');

    if (response.statusCode == 200) {
     List jsonData  = response.data;
        final List<Data1> posts = [];
      for (var item in jsonData) {
        final data = Data1.fromJson(item);
        posts.add(data);
      }
      return jsonData.map((e) => Data1.fromJson(e)).toList();
    } else {
      // Handle API error
      print('API request failed with status code ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // Handle exceptions
    print('Error occurred: $e');
    return [];
  }
}

Future<List<Data2>> fetchDataFromAPI2() async {
  try {
    final dio = Dio();
    final response = await dio.get('https://jsonplaceholder.typicode.com/photos/?_limit=3');

    if (response.statusCode == 200) {
      List jsonData  = response.data;
        final List<Data2> posts = [];
      for (var item in jsonData) {
        final data = Data2.fromJson(item);
        posts.add(data);
      }
      return jsonData.map((e) => Data2.fromJson(e)).toList();
    } else {
      // Handle API error
      print('API request failed with status code ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // Handle exceptions
    print('Error occurred: $e');
    return [];
  }
}

  Future<List<Data>> fetchData(PostDao dao) async {
    final List<Data> posts = [];
    List jsonData;
    bool check = await checkConnectivity() as bool;
    if (check) {
      dao.deleteTable();
      print('aaaap$check');
      final dio = Dio();
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts/?_limit=3');

      jsonData = response.data;
      for (var item in jsonData) {
        // final post = Post(item['id'], item['title']);
        final data = Data.fromJson(item);
        print('aaaaa${data.toString()}');
        posts.add(data);
      }
      dao.insertPost(posts);

      return jsonData.map((e) => Data.fromJson(e)).toList();
    } else {
      print('aaaap2${dao.findAllPost()}');
      return dao.findAllPost();
    }
  }
}

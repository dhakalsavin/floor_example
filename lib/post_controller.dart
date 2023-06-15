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

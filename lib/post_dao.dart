import 'package:floor/floor.dart';
import 'post.dart';

@dao
abstract class PostDao {
  @Query('SELECT * FROM Data')
  Future<List<Data>> findAllPost();

  @Query('SELECT title FROM Data')
  Stream<List<String>> findAllPostTitle();

  @Query('SELECT * FROM Data WHERE id = :id')
  Future<Data?> findAllPostId(int id);

  @insert
  Future<void> insertPost(List<Data> data);
}

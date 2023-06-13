import 'package:floor/floor.dart';
import 'post.dart';

@dao
abstract class PostDao {
  @Query('SELECT * FROM Post')
  Future<List<Post>> findAllPost();

  @Query('SELECT title FROM Post')
  Stream<List<String>> findAllPostTitle();

  @Query('SELECT * FROM Post WHERE id = :id')
  Stream<Post?> findPostById(int id);

  @insert
  Future<void> insertPost(List<Post> post);
}

import 'package:floor/floor.dart';

@entity
class Post {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String title;

  Post(this.id, this.title);
}

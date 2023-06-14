import 'package:floor/floor.dart';
import 'post_dao.dart';
import 'post.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Data])
abstract class AppDatabase extends FloorDatabase {
  PostDao get postDao;
}

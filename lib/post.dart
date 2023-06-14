import 'package:floor/floor.dart';

@entity
class Data {
  @PrimaryKey(autoGenerate: true)
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

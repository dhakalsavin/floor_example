import 'package:floor/floor.dart';

@entity
class Data {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String title;
  final String url;

  Data({
    required this.id,
    required this.title,
    required this.url
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
      url: json['url']?? ''
    );
  }
}



class Data1 {
  final int id;
  final String title;
  Data1({
    required this.id,
    required this.title,

  });

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
      id: json['id'],
      title: json['title'],

    );
  }
}


@entity
class Data2 {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String url;

  Data2({
    required this.id,
    required this.url
  });

  factory Data2.fromJson(Map<String, dynamic> json) {
    return Data2(
      id: json['id'],
  
      url: json['url']
    );
  }
}

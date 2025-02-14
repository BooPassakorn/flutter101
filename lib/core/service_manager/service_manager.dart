import 'package:dio/dio.dart';

class Repository {

  void getData() async {
    Response response;
    var dio = Dio();
    response = await dio.get("http://jsonblob.com/api/1334054917933031424");
    print(response.data.toString());
  }
}
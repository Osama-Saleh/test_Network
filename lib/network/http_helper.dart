// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:netwrok/model/post_model.dart';

// class HttpHelper {
//   static var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
//   static PostModel? postModel;
//   static Future getDate() async {
//     var response = await http.get(url);
//     var responseBody = jsonDecode(response.body) ;

//     if (response.statusCode == 200) {
//       print("response body : ${responseBody}");
//       // postModel = PostModel.fromJson(responseBody);
//       return PostModel.fromJson(responseBody);
//     } else {
//       print("Error no loading data");
//     }
//   }
// }
import 'dart:convert';

import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio();
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: "https://fakestoreapi.com/products",
      receiveDataWhenStatusError: true,
      // headers: {"Content-Type": "application/json"}
    ));
  }

  static Future getData() async {
    final response =
        await dio.get('https://fakestoreapi.com/products');
    // print("response $response");
  //  var myResponse = jsonDecode(response.data);
    return response;
  }
}

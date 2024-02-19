import 'dart:convert';
import 'dart:developer';
import 'package:ezi_taskmanager/api/user_model.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiService {
  Future<List<UserModel>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);

      print(response.body);

      if (response.statusCode == 200) {
        List<Datum> datumList = datumListFromJson(response.body);
        List<UserModel> userModelList = datumList.map((datum) {
          return UserModel(
            success: true, // Set your success value here
            message: '', // Set your message value here
            data: [datum], // Convert Datum object to a list of Datum objects
          );
        }).toList();

        return userModelList;
      } else {
        // Handle non-200 status codes if needed
        log('Non-200 status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

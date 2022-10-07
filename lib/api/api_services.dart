import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:programming_hero/app_config.dart';

class ApiService {
  Future<dynamic> questions() async {
    var response = await http.get(Uri.parse(url));

    print('questions');
    print(jsonDecode(response.body));

    return jsonDecode(response.body);
  }
}

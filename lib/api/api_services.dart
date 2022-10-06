import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> questions() async {
    var response = await http.get(
        Uri.parse('https://herosapp.nyc3.digitaloceanspaces.com/quiz.json'));

    print('questions');
    print(jsonDecode(response.body));

    return jsonDecode(response.body);
  }
}

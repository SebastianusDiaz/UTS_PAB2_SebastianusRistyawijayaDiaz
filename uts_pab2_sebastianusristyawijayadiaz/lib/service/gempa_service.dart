import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gempa_models.dart';

class GempaService {
  static Future<Gempa> fetchGempa() async {
    final url = Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Gempa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load gempa data');
    }
  }
}

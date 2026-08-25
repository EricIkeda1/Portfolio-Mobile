import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/portfolio_data.dart';

class PortfolioApi {
  static const String baseUrl = String.fromEnvironment(
    'PORTFOLIO_API_BASE_URL',
    defaultValue: 'https://ericyikedaportfolio5.vercel.app',
  );

  Future<PortfolioData> load() async {
    final uri = Uri.parse('$baseUrl/api/mobile-data');

    final response = await http
        .get(
          uri,
          headers: const {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode} ao carregar o portfólio.');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.toLowerCase().contains('application/json')) {
      throw const FormatException('A API não retornou JSON.');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw const FormatException('Resposta da API em formato inválido.');
    }

    final map = Map<String, dynamic>.from(decoded);

    if (map['error'] != null) {
      throw Exception(map['error'].toString());
    }

    final data = PortfolioData.fromJson(map);

    if (data.settings.aboutText.trim().isEmpty) {
      throw const FormatException(
        'portfolio_settings não foi retornado pela API.',
      );
    }

    return data;
  }

}

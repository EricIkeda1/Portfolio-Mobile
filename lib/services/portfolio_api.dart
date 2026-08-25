import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/portfolio_data.dart';

class PortfolioApi {
  static const String baseUrl = String.fromEnvironment(
    'PORTFOLIO_API_BASE_URL',
    defaultValue: 'https://ericyikedaportfolio5.vercel.app',
  );

  static const List<String> _paths = [
    '/api/mobile-data',
    '/api/data',
  ];

  Future<PortfolioData> load() async {
    Object? lastError;

    for (final path in _paths) {
      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl$path'),
              headers: const {'Accept': 'application/json'},
            )
            .timeout(const Duration(seconds: 12));

        if (response.statusCode < 200 || response.statusCode >= 300) {
          lastError = Exception('HTTP ${response.statusCode} em $path');
          continue;
        }

        final decoded = jsonDecode(response.body);

        if (decoded is! Map) {
          lastError = const FormatException('Resposta da API não é um objeto.');
          continue;
        }

        final data = PortfolioData.fromJson(
          Map<String, dynamic>.from(decoded),
        );

        if (data.projects.isEmpty && data.settings.aboutText.isEmpty) {
          lastError = const FormatException('A API retornou dados vazios.');
          continue;
        }

        return data;
      } catch (error) {
        lastError = error;
      }
    }

    throw Exception('Não foi possível carregar o portfólio: $lastError');
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/github_status.dart';

class GitHubService {
  static const String username = 'EricIkeda1';

  static const _headers = {
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };

  Future<GitHubStatus> loadStatus() async {
    final responses = await Future.wait([
      http
          .get(
            Uri.parse('https://api.github.com/users/$username'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10)),
      http
          .get(
            Uri.parse('https://api.github.com/users/$username/events/public?per_page=10'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10)),
    ]);

    final profileResponse = responses[0];
    final eventsResponse = responses[1];

    if (profileResponse.statusCode < 200 || profileResponse.statusCode >= 300) {
      throw Exception('GitHub perfil: HTTP ${profileResponse.statusCode}');
    }

    final profileDecoded = jsonDecode(profileResponse.body);
    if (profileDecoded is! Map) {
      throw const FormatException('Perfil do GitHub inválido.');
    }

    List<dynamic> events = const [];
    if (eventsResponse.statusCode >= 200 && eventsResponse.statusCode < 300) {
      final eventsDecoded = jsonDecode(eventsResponse.body);
      if (eventsDecoded is List) {
        events = eventsDecoded;
      }
    }

    return GitHubStatus.fromJson(
      profile: Map<String, dynamic>.from(profileDecoded),
      events: events,
    );
  }
}

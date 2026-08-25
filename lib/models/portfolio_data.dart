import 'package:flutter/material.dart';

class PortfolioSettings {
  final String aboutText;
  final String? profileImageUrl;
  final String whatsapp;
  final String email;
  final String github;

  const PortfolioSettings({
    required this.aboutText,
    required this.profileImageUrl,
    required this.whatsapp,
    required this.email,
    required this.github,
  });

  factory PortfolioSettings.fromJson(Map<String, dynamic> json) {
    return PortfolioSettings(
      aboutText: (json['about_text'] ?? json['aboutText'] ?? '').toString(),
      profileImageUrl:
          (json['profile_image_url'] ?? json['profileImageUrl'])?.toString(),
      whatsapp: (json['whatsapp'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      github: (json['github'] ?? '').toString(),
    );
  }
}

class PortfolioProject {
  final int id;
  final String name;
  final String type;
  final String description;
  final List<String> tags;
  final List<String> highlights;
  final String github;
  final String color;
  final String? imageUrl;
  final int sortOrder;

  const PortfolioProject({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.tags,
    required this.highlights,
    required this.github,
    required this.color,
    required this.imageUrl,
    required this.sortOrder,
  });

  factory PortfolioProject.fromJson(Map<String, dynamic> json) {
    List<String> listValue(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return const [];
    }

    return PortfolioProject(
      id: int.tryParse((json['id'] ?? 0).toString()) ?? 0,
      name: (json['name'] ?? json['title'] ?? '').toString(),
      type: (json['type'] ?? json['subtitle'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      tags: listValue(json['tags'] ?? json['technologies']),
      highlights: listValue(json['highlights'] ?? json['features']),
      github: (json['github'] ?? json['url'] ?? '').toString(),
      color: (json['color'] ?? '#7357F6').toString(),
      imageUrl: (json['image_url'] ?? json['imageUrl'])?.toString(),
      sortOrder: int.tryParse((json['sort_order'] ?? 0).toString()) ?? 0,
    );
  }

  Color get accent {
    final clean = color.replaceAll('#', '');
    final parsed = int.tryParse(
      clean.length == 6 ? 'FF$clean' : clean,
      radix: 16,
    );
    return Color(parsed ?? 0xFF7357F6);
  }
}

class PortfolioData {
  final PortfolioSettings settings;
  final List<PortfolioProject> projects;

  const PortfolioData({
    required this.settings,
    required this.projects,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawSettings = root['settings'] ??
        root['portfolio_settings'] ??
        root['config'];

    final rawProjects = root['projects'] ??
        root['portfolio_projects'] ??
        root['projetos'] ??
        <dynamic>[];

    return PortfolioData(
      settings: PortfolioSettings.fromJson(
        rawSettings is Map
            ? Map<String, dynamic>.from(rawSettings)
            : <String, dynamic>{},
      ),
      projects: rawProjects is List
          ? rawProjects
              .whereType<Map>()
              .map((e) => PortfolioProject.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
    );
  }

}

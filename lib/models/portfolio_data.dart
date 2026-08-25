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
        root['config'] ??
        <String, dynamic>{};

    final rawProjects = root['projects'] ??
        root['portfolio_projects'] ??
        root['projetos'] ??
        <dynamic>[];

    return PortfolioData(
      settings: PortfolioSettings.fromJson(
        rawSettings is Map<String, dynamic>
            ? rawSettings
            : Map<String, dynamic>.from(rawSettings as Map),
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

  static const fallback = PortfolioData(
    settings: PortfolioSettings(
      aboutText:
          'Meu nome é Eric, sou desenvolvedor de software e gosto de pegar uma ideia e transformar em algo que realmente funcione. Desenvolvo sites, sistemas e aplicações, sempre tentando deixar tudo bem organizado, rápido e fácil de usar.\n\nGosto de acompanhar o projeto desde o começo, pensando em como ele vai funcionar, como vai ficar visualmente e também em como deixar o código bem feito. Pra mim, não adianta só ficar bonito, tem que funcionar bem e fazer sentido pra quem vai usar.\n\nTambém gosto bastante de criar projetos próprios, principalmente pra testar ideias, aprender coisas novas e melhorar como desenvolvedor.',
      profileImageUrl:
          'https://drive.google.com/thumbnail?id=18I4wMhuprbKT0OLBLvAvz12yAoPNQSNc&sz=w1000',
      whatsapp: '(43)99636-9387',
      email: 'ikedayuji.2002@gmail.com',
      github: 'https://github.com/EricIkeda1',
    ),
    projects: [
      PortfolioProject(
        id: 5,
        name: 'Proj Galeria De Fotos',
        type: 'Sistema Web',
        description:
            'Desenvolvi uma plataforma web para divulgação de ensaios e trabalhos fotográficos. O projeto conta com galerias, sistema de login e uma área para adicionar novos conteúdos diretamente pelo site.',
        tags: ['React'],
        highlights: ['Autenticidade'],
        github: 'https://blogjovemribeiro.vercel.app/',
        color: '#4285FF',
        imageUrl: null,
        sortOrder: 1,
      ),
      PortfolioProject(
        id: 1,
        name: 'Ademiconnect',
        type: 'CRM Mobile',
        description:
            'CRM Mobile desenvolvido com Flutter e Supabase, com sincronização em tempo real e funcionamento offline. Solução completa para gestão de relacionamento com clientes.',
        tags: ['Flutter', 'Supabase', 'Mobile'],
        highlights: [
          'Sync em tempo real',
          'Modo offline',
          'Flutter + Supabase',
        ],
        github: 'https://github.com/EricIkeda1/Ademiconnect',
        color: '#4285FF',
        imageUrl: null,
        sortOrder: 2,
      ),
      PortfolioProject(
        id: 2,
        name: 'Temperlights',
        type: 'App Industrial',
        description:
            'Aplicativo para rastreabilidade da produção industrial, com acompanhamento em tempo real de cada etapa do processo de fabricação.',
        tags: ['Mobile', 'Rastreabilidade', 'Produção'],
        highlights: [
          'Rastreabilidade',
          'Produção industrial',
          'Tempo real',
        ],
        github: 'https://github.com/EricIkeda1/Temperlights-Mobile',
        color: '#5B9BFF',
        imageUrl: null,
        sortOrder: 3,
      ),
      PortfolioProject(
        id: 3,
        name: 'X4Glass',
        type: 'Sistema Web',
        description:
            'Sistema de rastreabilidade para produção de vidros desenvolvido em equipe. Projeto colaborativo com foco em qualidade e organização de processos industriais.',
        tags: ['Full Stack', 'Rastreabilidade', 'Equipe'],
        highlights: [
          'Desenvolvimento em equipe',
          'Rastreabilidade',
          'Full Stack',
        ],
        github: 'https://github.com/EricIkeda1/X4Glass',
        color: '#7AB3FF',
        imageUrl: null,
        sortOrder: 4,
      ),
    ],
  );
}

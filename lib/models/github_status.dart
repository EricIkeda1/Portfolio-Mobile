class GitHubStatus {
  final String username;
  final String profileUrl;
  final String avatarUrl;
  final int publicRepos;
  final int followers;
  final DateTime? lastActivityAt;
  final String? lastEventType;
  final String? lastRepository;

  const GitHubStatus({
    required this.username,
    required this.profileUrl,
    required this.avatarUrl,
    required this.publicRepos,
    required this.followers,
    required this.lastActivityAt,
    required this.lastEventType,
    required this.lastRepository,
  });

  factory GitHubStatus.fromJson({
    required Map<String, dynamic> profile,
    required List<dynamic> events,
  }) {
    Map<String, dynamic>? latest;
    for (final event in events) {
      if (event is Map<String, dynamic>) {
        latest = event;
        break;
      }
      if (event is Map) {
        latest = Map<String, dynamic>.from(event);
        break;
      }
    }

    DateTime? lastActivity;
    final createdAt = latest?['created_at']?.toString();
    if (createdAt != null && createdAt.isNotEmpty) {
      lastActivity = DateTime.tryParse(createdAt)?.toLocal();
    }

    final repo = latest?['repo'];
    String? repoName;
    if (repo is Map) {
      repoName = repo['name']?.toString();
    }

    return GitHubStatus(
      username: (profile['login'] ?? 'EricIkeda1').toString(),
      profileUrl:
          (profile['html_url'] ?? 'https://github.com/EricIkeda1').toString(),
      avatarUrl: (profile['avatar_url'] ?? '').toString(),
      publicRepos: int.tryParse((profile['public_repos'] ?? 0).toString()) ?? 0,
      followers: int.tryParse((profile['followers'] ?? 0).toString()) ?? 0,
      lastActivityAt: lastActivity,
      lastEventType: latest?['type']?.toString(),
      lastRepository: repoName,
    );
  }

  Duration? get activityAge {
    if (lastActivityAt == null) return null;
    return DateTime.now().difference(lastActivityAt!);
  }

  String get statusLabel {
    final age = activityAge;
    if (age == null) return 'GitHub disponível';
    if (age.inHours < 24) return 'Ativo hoje';
    if (age.inDays < 3) return 'Ativo recentemente';
    if (age.inDays < 7) return 'Atividade nesta semana';
    if (age.inDays < 30) return 'Atividade recente';
    return 'Sem atividade pública recente';
  }

  String get activityDescription {
    final age = activityAge;
    if (age == null) return 'Perfil público conectado';

    final time = age.inMinutes < 60
        ? 'há ${age.inMinutes.clamp(1, 59)} min'
        : age.inHours < 24
            ? 'há ${age.inHours}h'
            : age.inDays == 1
                ? 'há 1 dia'
                : 'há ${age.inDays} dias';

    final repo = lastRepository;
    if (repo != null && repo.isNotEmpty) {
      final shortRepo = repo.contains('/') ? repo.split('/').last : repo;
      return '$time • $shortRepo';
    }
    return time;
  }

  bool get isRecentlyActive {
    final age = activityAge;
    return age != null && age.inDays < 3;
  }

  static const fallback = GitHubStatus(
    username: 'EricIkeda1',
    profileUrl: 'https://github.com/EricIkeda1',
    avatarUrl: '',
    publicRepos: 0,
    followers: 0,
    lastActivityAt: null,
    lastEventType: null,
    lastRepository: null,
  );
}

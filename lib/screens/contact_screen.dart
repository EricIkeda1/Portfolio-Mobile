import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';

class ContactScreen extends StatelessWidget {
  final PortfolioSettings settings;

  const ContactScreen({
    super.key,
    required this.settings,
  });

  Future<void> _launch(String uri) async {
    final url = Uri.tryParse(uri);
    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String get _phoneDigits =>
      settings.whatsapp.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Contato')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
        children: [
          Text(
            'Tem uma ideia, projeto ou oportunidade? Entre em contato comigo.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                _ContactTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'E-mail',
                  subtitle: settings.email,
                  onTap: () => _launch('mailto:${settings.email}'),
                ),
                _ContactTile(
                  icon: Icons.chat_rounded,
                  title: 'WhatsApp',
                  subtitle: settings.whatsapp,
                  onTap: () => _launch('https://wa.me/55$_phoneDigits'),
                ),
                _ContactTile(
                  icon: Icons.code_rounded,
                  title: 'GitHub',
                  subtitle: settings.github.replaceFirst('https://', ''),
                  onTap: () => _launch(settings.github),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vamos conversar?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posso responder por e-mail ou WhatsApp.',
                  style: TextStyle(color: colors.onPrimaryContainer),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _launch('mailto:${settings.email}'),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Enviar e-mail'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

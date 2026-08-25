import 'package:flutter/material.dart';

import '../models/portfolio_data.dart';
import '../services/external_link_service.dart';

class ContactScreen extends StatelessWidget {
  final PortfolioSettings settings;

  const ContactScreen({
    super.key,
    required this.settings,
  });



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
                  onTap: () => ExternalLinkService.openEmail(context, settings.email),
                ),
                _ContactTile(
                  icon: Icons.chat_rounded,
                  title: 'WhatsApp',
                  subtitle: settings.whatsapp,
                  onTap: () => ExternalLinkService.openWhatsApp(context, settings.whatsapp),
                ),
                _ContactTile(
                  icon: Icons.code_rounded,
                  title: 'GitHub',
                  subtitle: settings.github.replaceFirst('https://', ''),
                  onTap: () => ExternalLinkService.openUrl(
                    context,
                    settings.github,
                    errorMessage: 'Não foi possível abrir o GitHub.',
                  ),
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
                  onPressed: () => ExternalLinkService.openEmail(context, settings.email),
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

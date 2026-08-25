import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLinkService {
  static Future<void> openUrl(
    BuildContext context,
    String value, {
    String errorMessage = 'Não foi possível abrir este link.',
  }) async {
    final uri = Uri.tryParse(value.trim());
    if (uri == null) {
      _showError(context, errorMessage);
      return;
    }

    try {
      var opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        opened = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }

      if (!opened && context.mounted) {
        _showError(context, errorMessage);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context, errorMessage);
      }
    }
  }

  static Future<void> openEmail(BuildContext context, String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email.trim(),
      queryParameters: const {
        'subject': 'Contato pelo portfólio',
      },
    );

    try {
      var opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
      if (!opened && context.mounted) {
        _showError(context, 'Nenhum aplicativo de e-mail foi encontrado.');
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context, 'Não foi possível abrir o aplicativo de e-mail.');
      }
    }
  }

  static Future<void> openWhatsApp(
    BuildContext context,
    String phone,
  ) async {
    var digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      _showError(context, 'Número do WhatsApp inválido.');
      return;
    }

    if (!digits.startsWith('55')) {
      digits = '55$digits';
    }

    final uri = Uri.https(
      'wa.me',
      '/$digits',
      {'text': 'Olá! Vim pelo seu portfólio.'},
    );

    await openUrl(
      context,
      uri.toString(),
      errorMessage: 'Não foi possível abrir o WhatsApp.',
    );
  }

  static void _showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

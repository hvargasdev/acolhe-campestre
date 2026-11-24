/// Atalhos para ligar, abrir o mapa, o WhatsApp e sites a partir do app.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> ligar(BuildContext context, String numero) =>
    _abrir(context, Uri(scheme: 'tel', path: numero));

Future<void> abrirMapa(BuildContext context, String endereco) => _abrir(
  context,
  Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': '$endereco, São Leopoldo - RS',
  }),
);

Future<void> abrirWhatsapp(BuildContext context, String numero) =>
    _abrir(context, Uri.https('wa.me', '/$numero'));

Future<void> abrirSite(BuildContext context, String url) =>
    _abrir(context, Uri.parse(url));

Future<void> _abrir(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.of(context);
  final abriu = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!abriu) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Não foi possível abrir. Tente de novo.')),
    );
  }
}

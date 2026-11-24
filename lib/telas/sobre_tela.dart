import 'package:flutter/material.dart';

import '../dados/orientacoes.dart';
import '../dados/questionarios.dart';
import '../util/abrir.dart';

/// Link do formulário de feedback (Google Forms). Enquanto estiver vazio, o
/// botão "Dar minha opinião" não aparece.
const linkFeedback = '';

const versaoApp = '1.0.0';

class SobreTela extends StatelessWidget {
  const SobreTela({super.key});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o app')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Acolhe Campestre', style: texto.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'App gratuito para moradores do bairro Campestre, em São '
              'Leopoldo/RS, criado como projeto de extensão do curso de '
              'Desenvolvimento Mobile da UNINTER.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(avisoNaoEDiagnostico, style: texto.bodyLarge),
            const SizedBox(height: 16),
            Text('Privacidade', style: texto.titleMedium),
            Text(
              'O app não tem cadastro e não guarda nem envia as suas '
              'respostas.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text('Questionários', style: texto.titleMedium),
            Text(
              'PHQ-9 (humor) e GAD-7 (ansiedade), versões oficiais em '
              'português do Brasil. $creditoInstrumentos',
              style: texto.bodyMedium,
            ),
            if (linkFeedback.isNotEmpty) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => abrirSite(context, linkFeedback),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Dar minha opinião'),
              ),
            ],
            const SizedBox(height: 24),
            Text('Versão $versaoApp', style: texto.bodySmall),
          ],
        ),
      ),
    );
  }
}

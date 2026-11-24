import 'package:flutter/material.dart';

import '../dados/questionarios.dart';
import '../modelos/questionario.dart';
import '../util/abrir.dart';
import 'onde_buscar_ajuda_tela.dart';
import 'questionario_tela.dart';
import 'sobre_tela.dart';

class InicioTela extends StatelessWidget {
  const InicioTela({super.key});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acolhe Campestre'),
        actions: [
          IconButton(
            tooltip: 'Sobre o app',
            icon: const Icon(Icons.info_outline),
            onPressed: () => _abrir(context, const SobreTela()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Como você tem se sentido?', style: texto.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Responda a algumas perguntas sobre as últimas 2 semanas. '
              'Leva cerca de 2 minutos.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 20),
            _BotaoQuestionario(
              questionario: phq9,
              titulo: 'Como está meu humor?',
              icone: Icons.sentiment_neutral_outlined,
            ),
            const SizedBox(height: 12),
            _BotaoQuestionario(
              questionario: gad7,
              titulo: 'Como está minha ansiedade?',
              icone: Icons.air_outlined,
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            Text('Precisa de ajuda agora?', style: texto.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Veja onde buscar atendimento gratuito em São Leopoldo, com '
              'telefone e endereço.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _abrir(context, const OndeBuscarAjudaTela()),
              icon: const Icon(Icons.local_hospital_outlined),
              label: const Text('Onde buscar ajuda'),
            ),
            if (linkFeedback.isNotEmpty) ...[
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: () => abrirSite(context, linkFeedback),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Dar minha opinião sobre o app'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BotaoQuestionario extends StatelessWidget {
  const _BotaoQuestionario({
    required this.questionario,
    required this.titulo,
    required this.icone,
  });

  final Questionario questionario;
  final String titulo;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () =>
          _abrir(context, QuestionarioTela(questionario: questionario)),
      child: Row(
        children: [
          Icon(icone, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo),
                Text(
                  '${questionario.sigla} – ${questionario.itens.length} perguntas',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _abrir(BuildContext context, Widget tela) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
}

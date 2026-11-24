import 'package:flutter/material.dart';

class TermoTela extends StatelessWidget {
  const TermoTela({super.key, required this.aoAceitar});

  final VoidCallback aoAceitar;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(
                'Boas-vindas ao Acolhe Campestre',
                style: texto.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Este app ajuda você a perceber sinais de ansiedade e depressão '
              'e a encontrar atendimento gratuito em São Leopoldo.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 16),
            const _Item(
              icone: Icons.medical_information_outlined,
              texto:
                  'Ele não faz diagnóstico e não substitui o atendimento de '
                  'um profissional de saúde.',
            ),
            const _Item(
              icone: Icons.lock_outline,
              texto:
                  'Você não precisa se cadastrar. Suas respostas não são '
                  'salvas nem enviadas para ninguém: elas somem quando você '
                  'sai do resultado.',
            ),
            const _Item(
              icone: Icons.call_outlined,
              texto:
                  'Em uma emergência, ligue para o SAMU (192). Para '
                  'conversar com alguém agora, ligue para o CVV (188).',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: aoAceitar,
              child: const Text('Entendi, quero continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icone, required this.texto});

  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              icone,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

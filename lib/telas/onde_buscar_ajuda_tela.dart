import 'package:flutter/material.dart';

import '../dados/servicos.dart';
import '../tema.dart';
import '../util/abrir.dart';
import '../widgets/cartao_servico.dart';

class OndeBuscarAjudaTela extends StatelessWidget {
  const OndeBuscarAjudaTela({super.key});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Onde buscar ajuda')),
      body: SafeArea(
        child: Column(
          children: [
            const FaixaEmergencia(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Todos os serviços abaixo são gratuitos. A UBS também '
                    'atende saúde mental e é o primeiro lugar para procurar.',
                    style: texto.bodyLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A UBS de referência depende da sua rua. Se não souber '
                    'qual é a sua, ligue para uma delas ou fale com o Zap da '
                    'Saúde.',
                    style: texto.bodyMedium,
                  ),
                  for (final grupo in GrupoServico.values) ...[
                    const SizedBox(height: 20),
                    Semantics(
                      header: true,
                      child: Text(
                        tituloDoGrupo[grupo]!,
                        style: texto.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final s in servicos.where((s) => s.grupo == grupo))
                      CartaoServico(servico: s),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Informações conferidas em $dataConferenciaServicos no '
                    'site da Prefeitura de São Leopoldo. Horários podem '
                    'mudar: na dúvida, ligue antes.',
                    style: texto.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Atalhos sempre visíveis para o CVV e o SAMU.
class FaixaEmergencia extends StatelessWidget {
  const FaixaEmergencia({super.key});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final estiloBotao = FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: corAlerta,
      minimumSize: const Size.fromHeight(48),
    );

    return Container(
      width: double.infinity,
      color: corAlerta,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Precisa falar com alguém agora?',
            style: texto.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: estiloBotao,
                  onPressed: () => ligar(context, '188'),
                  icon: const Icon(Icons.call),
                  label: const Text(
                    'CVV 188',
                    semanticsLabel: 'Ligar para o CVV, 188',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  style: estiloBotao,
                  onPressed: () => ligar(context, '192'),
                  icon: const Icon(Icons.emergency),
                  label: const Text(
                    'SAMU 192',
                    semanticsLabel: 'Ligar para o SAMU, 192',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

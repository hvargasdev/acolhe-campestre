import 'package:flutter/material.dart';

import '../dados/servicos.dart';
import '../widgets/cartao_servico.dart';

class OndeBuscarAjudaTela extends StatelessWidget {
  const OndeBuscarAjudaTela({super.key});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Onde buscar ajuda')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Todos os serviços abaixo são gratuitos. A UBS também atende '
              'saúde mental e é o primeiro lugar para procurar.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'A UBS de referência depende da sua rua. Se não souber qual é a '
              'sua, ligue para uma delas ou fale com o Zap da Saúde.',
              style: texto.bodyMedium,
            ),
            for (final grupo in GrupoServico.values) ...[
              const SizedBox(height: 20),
              Semantics(
                header: true,
                child: Text(tituloDoGrupo[grupo]!, style: texto.titleLarge),
              ),
              const SizedBox(height: 8),
              for (final s in servicos.where((s) => s.grupo == grupo))
                CartaoServico(servico: s),
            ],
            const SizedBox(height: 16),
            Text(
              'Informações conferidas em $dataConferenciaServicos no site da '
              'Prefeitura de São Leopoldo. Horários podem mudar: na dúvida, '
              'ligue antes.',
              style: texto.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../dados/orientacoes.dart';
import '../dados/servicos.dart';
import '../modelos/questionario.dart';
import '../tema.dart';
import '../widgets/cartao_servico.dart';
import 'onde_buscar_ajuda_tela.dart';

class ResultadoTela extends StatelessWidget {
  const ResultadoTela({super.key, required this.resultado});

  final Resultado resultado;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final r = resultado;
    final cor = corDoNivel(r.faixa.nivel);

    return Scaffold(
      appBar: AppBar(title: Text('Resultado – ${r.questionario.tema}')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Semantics(
              label:
                  'Faixa ${r.faixa.nome}, ${r.pontuacao} de '
                  '${r.questionario.pontuacaoMaxima} pontos',
              child: ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.08),
                    border: Border.all(color: cor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Faixa', style: texto.labelLarge),
                      Text(
                        r.faixa.nome,
                        style: texto.headlineMedium?.copyWith(color: cor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${r.pontuacao} de ${r.questionario.pontuacaoMaxima} '
                        'pontos no ${r.questionario.sigla}',
                        style: texto.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(orientacaoPorNivel[r.faixa.nivel]!, style: texto.bodyLarge),
            const SizedBox(height: 16),
            Text(
              avisoNaoEDiagnostico,
              style: texto.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            if (r.precisaApoioImediato) ...[
              const SizedBox(height: 20),
              CartaoServico(
                servico: servicoPorNome('CVV – Centro de Valorização da Vida'),
              ),
            ] else if (r.faixa.nivel != NivelAtencao.minimo) ...[
              const SizedBox(height: 20),
              CartaoServico(servico: servicoPorNome('UBS Vila Nova')),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OndeBuscarAjudaTela()),
              ),
              icon: const Icon(Icons.local_hospital_outlined),
              label: const Text('Ver onde buscar ajuda'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}

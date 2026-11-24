import 'package:flutter/material.dart';

import '../dados/orientacoes.dart';
import '../dados/servicos.dart';
import '../modelos/questionario.dart';
import '../tema.dart';
import '../widgets/cartao_servico.dart';
import 'resultado_tela.dart';

/// Mostrada antes do resultado quando a pergunta 9 do PHQ-9 é acima de zero.
class ApoioImediatoTela extends StatelessWidget {
  const ApoioImediatoTela({super.key, required this.resultado});

  final Resultado resultado;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Você não está sozinho/a'),
        backgroundColor: corAlerta,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(textoApoioImediato, style: texto.titleMedium),
            const SizedBox(height: 12),
            Text(
              'Se você está em perigo agora, ligue para o SAMU (192). Para '
              'conversar com alguém neste momento, ligue para o CVV (188): é '
              'gratuito e funciona 24 horas.',
              style: texto.bodyLarge,
            ),
            const SizedBox(height: 16),
            CartaoServico(
              servico: servicoPorNome('CVV – Centro de Valorização da Vida'),
            ),
            CartaoServico(servico: servicoPorNome('SAMU')),
            CartaoServico(
              servico: servicoPorNome('Pronto-Socorro do Hospital Centenário'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ResultadoTela(resultado: resultado),
                ),
              ),
              child: const Text('Ver meu resultado'),
            ),
          ],
        ),
      ),
    );
  }
}

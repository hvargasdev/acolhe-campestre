import 'package:flutter/material.dart';

import '../modelos/questionario.dart';
import 'apoio_imediato_tela.dart';
import 'resultado_tela.dart';

/// Uma pergunta por vez. As respostas ficam só na memória desta tela.
class QuestionarioTela extends StatefulWidget {
  const QuestionarioTela({super.key, required this.questionario});

  final Questionario questionario;

  @override
  State<QuestionarioTela> createState() => _QuestionarioTelaState();
}

class _QuestionarioTelaState extends State<QuestionarioTela> {
  final List<int> _respostas = [];

  Questionario get _q => widget.questionario;
  int get _atual => _respostas.length;

  void _responder(int pontos) {
    setState(() => _respostas.add(pontos));
    if (_respostas.length == _q.itens.length) _concluir();
  }

  void _voltar() {
    if (_respostas.isEmpty) {
      Navigator.of(context).pop();
    } else {
      setState(_respostas.removeLast);
    }
  }

  void _concluir() {
    final resultado = _q.calcular(_respostas);
    final proxima = resultado.precisaApoioImediato
        ? ApoioImediatoTela(resultado: resultado)
        : ResultadoTela(resultado: resultado);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => proxima));
  }

  @override
  Widget build(BuildContext context) {
    if (_atual >= _q.itens.length) return const Scaffold();
    final texto = Theme.of(context).textTheme;

    return PopScope(
      canPop: _respostas.isEmpty,
      onPopInvokedWithResult: (saiu, _) {
        if (!saiu) _voltar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_q.tema),
          leading: IconButton(
            tooltip: _respostas.isEmpty ? 'Sair' : 'Pergunta anterior',
            icon: const Icon(Icons.arrow_back),
            onPressed: _voltar,
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Semantics(
                label: 'Pergunta ${_atual + 1} de ${_q.itens.length}',
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pergunta ${_atual + 1} de ${_q.itens.length}',
                        style: texto.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _atual / _q.itens.length,
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(_q.enunciado, style: texto.bodyLarge),
              const SizedBox(height: 16),
              Semantics(
                header: true,
                child: Text(_q.itens[_atual], style: texto.headlineSmall),
              ),
              const SizedBox(height: 24),
              for (final opcao in _q.opcoes) ...[
                OutlinedButton(
                  onPressed: () => _responder(opcao.pontos),
                  child: Text(opcao.texto, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

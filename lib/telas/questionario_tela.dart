import 'package:flutter/material.dart';

import '../modelos/questionario.dart';
import 'apoio_imediato_tela.dart';
import 'resultado_tela.dart';

/// Uma pergunta por vez, com navegação livre entre as já respondidas e uma
/// revisão antes do resultado. As respostas ficam só na memória desta tela.
class QuestionarioTela extends StatefulWidget {
  const QuestionarioTela({super.key, required this.questionario});

  final Questionario questionario;

  @override
  State<QuestionarioTela> createState() => _QuestionarioTelaState();
}

class _QuestionarioTelaState extends State<QuestionarioTela> {
  late final List<int?> _respostas = List.filled(
    widget.questionario.itens.length,
    null,
  );
  int _indice = 0;
  bool _emRevisao = false;

  /// Verdadeiro quando a pergunta foi aberta a partir da revisão: ao
  /// responder, volta para a revisão em vez de seguir para a próxima.
  bool _editandoDaRevisao = false;

  Questionario get _q => widget.questionario;
  bool get _algumaRespondida => _respostas.any((r) => r != null);
  int get _primeiraSemResposta => _respostas.indexOf(null);

  Future<void> _escolher(int pontos) async {
    setState(() => _respostas[_indice] = pontos);
    // Pausa curta para a pessoa ver a opção marcada antes de avançar.
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() {
      if (_editandoDaRevisao || _primeiraSemResposta == -1) {
        _editandoDaRevisao = false;
        _emRevisao = true;
      } else if (_indice + 1 < _q.itens.length &&
          _respostas[_indice + 1] == null) {
        _indice++;
      } else {
        _indice = _primeiraSemResposta;
      }
    });
  }

  void _irPara(int indice) => setState(() {
    _indice = indice;
    _emRevisao = false;
    _editandoDaRevisao = false;
  });

  void _editarDaRevisao(int indice) => setState(() {
    _indice = indice;
    _emRevisao = false;
    _editandoDaRevisao = true;
  });

  void _voltar() {
    if (_emRevisao) {
      _irPara(_q.itens.length - 1);
    } else if (_indice > 0) {
      _irPara(_indice - 1);
    } else {
      _sair();
    }
  }

  Future<void> _sair() async {
    if (!_algumaRespondida) {
      Navigator.of(context).pop();
      return;
    }
    final sair = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Sair do questionário?'),
        content: const Text('As respostas que você já deu serão descartadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Continuar respondendo'),
          ),
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (sair == true && mounted) Navigator.of(context).pop();
  }

  void _verResultado() {
    final resultado = _q.calcular(_respostas.cast<int>());
    final proxima = resultado.precisaApoioImediato
        ? ApoioImediatoTela(resultado: resultado)
        : ResultadoTela(resultado: resultado);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => proxima));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (saiu, _) {
        if (!saiu) _voltar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_q.tema),
          leading: IconButton(
            tooltip: _emRevisao || _indice > 0 ? 'Voltar' : 'Sair',
            icon: const Icon(Icons.arrow_back),
            onPressed: _voltar,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _Passos(
                respostas: _respostas,
                atual: _emRevisao ? null : _indice,
                aoTocar: _irPara,
              ),
              Expanded(
                child: _emRevisao ? _revisao(context) : _pergunta(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pergunta(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final cores = Theme.of(context).colorScheme;
    final respostaAtual = _respostas[_indice];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Text(
          'Pergunta ${_indice + 1} de ${_q.itens.length}',
          style: texto.labelLarge?.copyWith(color: cores.primary),
        ),
        const SizedBox(height: 8),
        Text(
          _q.enunciado,
          style: texto.bodyMedium?.copyWith(color: cores.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: Text(_q.itens[_indice], style: texto.headlineSmall),
        ),
        const SizedBox(height: 20),
        for (final opcao in _q.opcoes) ...[
          _BotaoOpcao(
            texto: opcao.texto,
            selecionada: respostaAtual == opcao.pontos,
            aoTocar: () => _escolher(opcao.pontos),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            if (_indice > 0)
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _irPara(_indice - 1),
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Anterior'),
                ),
              )
            else
              const Spacer(),
            Expanded(
              child: TextButton.icon(
                onPressed: respostaAtual == null
                    ? null
                    : () => _primeiraSemResposta == -1
                          ? setState(() => _emRevisao = true)
                          : _irPara(
                              _indice + 1 < _q.itens.length
                                  ? _indice + 1
                                  : _primeiraSemResposta,
                            ),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right),
                label: Text(_primeiraSemResposta == -1 ? 'Revisar' : 'Próxima'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _revisao(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Semantics(
          header: true,
          child: Text('Confira suas respostas', style: texto.headlineSmall),
        ),
        const SizedBox(height: 4),
        Text(
          'Toque em uma pergunta para mudar a resposta.',
          style: texto.bodyLarge,
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _q.itens.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(_q.itens[i], style: texto.bodyLarge),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _q.opcoes.firstWhere((o) => o.pontos == _respostas[i]).texto,
                  style: texto.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _editarDaRevisao(i),
            ),
          ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _verResultado,
          child: const Text('Ver resultado'),
        ),
      ],
    );
  }
}

/// Indicador das perguntas: as respondidas e a próxima podem ser tocadas.
class _Passos extends StatelessWidget {
  const _Passos({
    required this.respostas,
    required this.atual,
    required this.aoTocar,
  });

  final List<int?> respostas;
  final int? atual;
  final ValueChanged<int> aoTocar;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final respondidas = respostas.where((r) => r != null).length;
    final proxima = respostas.indexOf(null);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: respondidas / respostas.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < respostas.length; i++)
                _Passo(
                  numero: i + 1,
                  respondida: respostas[i] != null,
                  atual: atual == i,
                  cores: cores,
                  aoTocar: respostas[i] != null || i == proxima
                      ? () => aoTocar(i)
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Passo extends StatelessWidget {
  const _Passo({
    required this.numero,
    required this.respondida,
    required this.atual,
    required this.cores,
    required this.aoTocar,
  });

  final int numero;
  final bool respondida;
  final bool atual;
  final ColorScheme cores;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final fundo = atual
        ? cores.primary
        : respondida
        ? cores.primaryContainer
        : cores.surfaceContainerHighest;
    final frente = atual
        ? cores.onPrimary
        : respondida
        ? cores.onPrimaryContainer
        : cores.onSurfaceVariant;
    final estado = atual
        ? 'atual'
        : respondida
        ? 'respondida'
        : 'sem resposta';

    return Semantics(
      button: aoTocar != null,
      label: 'Pergunta $numero, $estado',
      child: ExcludeSemantics(
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: aoTocar,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fundo,
              shape: BoxShape.circle,
              border: atual ? null : Border.all(color: cores.outlineVariant),
            ),
            child: respondida && !atual
                ? Icon(Icons.check, size: 20, color: frente)
                : Text(
                    '$numero',
                    style: TextStyle(
                      color: frente,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _BotaoOpcao extends StatelessWidget {
  const _BotaoOpcao({
    required this.texto,
    required this.selecionada,
    required this.aoTocar,
  });

  final String texto;
  final bool selecionada;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final conteudo = Row(
      children: [
        Icon(selecionada ? Icons.radio_button_checked : Icons.radio_button_off),
        const SizedBox(width: 12),
        Expanded(child: Text(texto)),
      ],
    );

    // MergeSemantics junta o "selecionado" ao nó do botão, para o leitor de
    // tela anunciar qual opção está marcada.
    return MergeSemantics(
      child: Semantics(
        selected: selecionada,
        child: selecionada
            ? FilledButton(onPressed: aoTocar, child: conteudo)
            : OutlinedButton(onPressed: aoTocar, child: conteudo),
      ),
    );
  }
}

/// Estruturas dos questionários de triagem (PHQ-9 e GAD-7) e do cálculo
/// do resultado. O app não faz diagnóstico: a faixa só orienta a busca
/// por atendimento.
library;

/// Nível de atenção de uma faixa, usado para escolher a orientação e as cores.
enum NivelAtencao { minimo, leve, moderado, alto }

class Opcao {
  const Opcao(this.texto, this.pontos);

  final String texto;
  final int pontos;
}

class Faixa {
  const Faixa({
    required this.min,
    required this.max,
    required this.nome,
    required this.nivel,
  });

  final int min;
  final int max;
  final String nome;
  final NivelAtencao nivel;

  bool contem(int pontuacao) => pontuacao >= min && pontuacao <= max;
}

class Questionario {
  const Questionario({
    required this.sigla,
    required this.tema,
    required this.titulo,
    required this.enunciado,
    required this.itens,
    required this.opcoes,
    required this.faixas,
    this.indiceItemDeRisco,
  });

  /// "PHQ-9" ou "GAD-7".
  final String sigla;

  /// Nome simples mostrado na tela inicial ("Humor", "Ansiedade").
  final String tema;

  /// Título do formulário oficial.
  final String titulo;

  /// Enunciado oficial, sem a instrução de marcar com "✔" (não se aplica ao app).
  final String enunciado;

  final List<String> itens;
  final List<Opcao> opcoes;
  final List<Faixa> faixas;

  /// Item que, com qualquer resposta acima de zero, leva à tela de apoio
  /// imediato (pergunta 9 do PHQ-9). Índice a partir de zero.
  final int? indiceItemDeRisco;

  int get pontuacaoMaxima => itens.length * opcoes.last.pontos;

  Resultado calcular(List<int> respostas) {
    if (respostas.length != itens.length) {
      throw ArgumentError(
          'Esperadas ${itens.length} respostas, recebidas ${respostas.length}.');
    }
    final pontosValidos = opcoes.map((o) => o.pontos).toSet();
    if (respostas.any((r) => !pontosValidos.contains(r))) {
      throw ArgumentError('Resposta fora das opções do questionário.');
    }

    final pontuacao = respostas.fold(0, (soma, r) => soma + r);
    final faixa = faixas.firstWhere((f) => f.contem(pontuacao));
    final risco =
        indiceItemDeRisco != null && respostas[indiceItemDeRisco!] > 0;

    return Resultado(
      questionario: this,
      pontuacao: pontuacao,
      faixa: faixa,
      precisaApoioImediato: risco,
    );
  }
}

class Resultado {
  const Resultado({
    required this.questionario,
    required this.pontuacao,
    required this.faixa,
    required this.precisaApoioImediato,
  });

  final Questionario questionario;
  final int pontuacao;
  final Faixa faixa;
  final bool precisaApoioImediato;
}

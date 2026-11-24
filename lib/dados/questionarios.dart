/// Textos oficiais em português do Brasil, copiados sem alteração dos
/// formulários publicados em phqscreeners.com (ver docs/fontes/):
/// "Não é necessária permissão para reproduzir, traduzir, exibir ou distribuir."
///
/// As faixas seguem os pontos de corte do manual oficial (5, 10, 15 e 20).
/// Os nomes das faixas em português são tradução nossa, já que os
/// formulários em português não trazem esses nomes.
library;

import '../modelos/questionario.dart';

const creditoInstrumentos =
    'Desenvolvido pelos Drs. Robert L. Spitzer, Janet B.W. Williams, Kurt '
    'Kroenke e colegas, com um subsídio educacional da Pfizer Inc. Não é '
    'necessária permissão para reproduzir, traduzir, exibir ou distribuir.';

const _opcoes = [
  Opcao('Nenhuma vez', 0),
  Opcao('Vários dias', 1),
  Opcao('Mais da metade dos dias', 2),
  Opcao('Quase todos os dias', 3),
];

const phq9 = Questionario(
  sigla: 'PHQ-9',
  tema: 'Humor',
  titulo: 'Questionário sobre a saúde do/a paciente (PHQ-9)',
  enunciado:
      'Durante as últimas 2 semanas, com que freqüência você foi '
      'incomodado/a por qualquer um dos problemas abaixo?',
  itens: [
    'Pouco interesse ou pouco prazer em fazer as coisas',
    'Se sentir “para baixo”, deprimido/a ou sem perspectiva',
    'Dificuldade para pegar no sono ou permanecer dormindo, ou dormir mais '
        'do que de costume',
    'Se sentir cansado/a ou com pouca energia',
    'Falta de apetite ou comendo demais',
    'Se sentir mal consigo mesmo/a — ou achar que você é um fracasso ou que '
        'decepcionou sua família ou você mesmo/a',
    'Dificuldade para se concentrar nas coisas, como ler o jornal ou ver '
        'televisão',
    'Lentidão para se movimentar ou falar, a ponto das outras pessoas '
        'perceberem? Ou o oposto – estar tão agitado/a ou irrequieto/a que '
        'você fica andando de um lado para o outro muito mais do que de '
        'costume',
    'Pensar em se ferir de alguma maneira ou que seria melhor estar morto/a',
  ],
  opcoes: _opcoes,
  faixas: [
    Faixa(min: 0, max: 4, nome: 'Mínima', nivel: NivelAtencao.minimo),
    Faixa(min: 5, max: 9, nome: 'Leve', nivel: NivelAtencao.leve),
    Faixa(min: 10, max: 14, nome: 'Moderada', nivel: NivelAtencao.moderado),
    Faixa(
      min: 15,
      max: 19,
      nome: 'Moderadamente grave',
      nivel: NivelAtencao.alto,
    ),
    Faixa(min: 20, max: 27, nome: 'Grave', nivel: NivelAtencao.alto),
  ],
  indiceItemDeRisco: 8,
);

const gad7 = Questionario(
  sigla: 'GAD-7',
  tema: 'Ansiedade',
  titulo: 'GAD-7',
  enunciado:
      'Durante as últimas 2 semanas, com que freqüência você foi '
      'incomodado/a pelos problemas abaixo?',
  itens: [
    'Sentir-se nervoso/a, ansioso/a ou muito tenso/a',
    'Não ser capaz de impedir ou de controlar as preocupações',
    'Preocupar-se muito com diversas coisas',
    'Dificuldade para relaxar',
    'Ficar tão agitado/a que se torna difícil permanecer sentado/a',
    'Ficar facilmente aborrecido/a ou irritado/a',
    'Sentir medo como se algo horrível fosse acontecer',
  ],
  opcoes: _opcoes,
  faixas: [
    Faixa(min: 0, max: 4, nome: 'Mínima', nivel: NivelAtencao.minimo),
    Faixa(min: 5, max: 9, nome: 'Leve', nivel: NivelAtencao.leve),
    Faixa(min: 10, max: 14, nome: 'Moderada', nivel: NivelAtencao.moderado),
    Faixa(min: 15, max: 21, nome: 'Grave', nivel: NivelAtencao.alto),
  ],
);

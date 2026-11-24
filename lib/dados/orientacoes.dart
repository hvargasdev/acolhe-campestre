/// Orientações mostradas no resultado, em linguagem simples. Não são texto
/// dos questionários oficiais: foram escritas para o app e não fazem
/// diagnóstico, só indicam onde buscar ajuda.
library;

import '../modelos/questionario.dart';

const avisoNaoEDiagnostico =
    'Este resultado não é um diagnóstico. Só um profissional de saúde pode '
    'avaliar o que você está sentindo.';

const orientacaoPorNivel = {
  NivelAtencao.minimo:
      'Nas últimas 2 semanas, você teve poucos ou nenhum '
      'desses sinais. Continue cuidando de você: dormir bem, se alimentar, se '
      'movimentar e conversar com pessoas de confiança. Se os sinais '
      'aparecerem ou aumentarem, refaça o questionário ou procure a UBS.',
  NivelAtencao.leve:
      'Você teve alguns desses sinais. Observe como se sente '
      'nas próximas semanas. Se os sinais continuarem ou atrapalharem o seu '
      'dia a dia, procure a UBS: ela também atende saúde mental, de graça.',
  NivelAtencao.moderado:
      'Esses sinais merecem atenção. Procure a UBS do '
      'bairro para conversar com a equipe de saúde. O atendimento é gratuito, '
      'pelo SUS.',
  NivelAtencao.alto:
      'Esses sinais estão fortes e merecem cuidado o quanto '
      'antes. Procure a UBS do bairro nos próximos dias. Se o sofrimento '
      'estiver muito intenso, você também pode ir direto ao CAPS Capilé, sem '
      'marcar horário.',
};

const textoApoioImediato =
    'Você contou que pensou em se ferir ou que seria '
    'melhor estar morto/a. Obrigado por responder com sinceridade. Você não '
    'está sozinho/a, e conversar com alguém ajuda.';

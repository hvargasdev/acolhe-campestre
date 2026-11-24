/// Serviços de saúde mental indicados pelo app.
///
/// Fontes: página "Rede de Atenção à Saúde" da Prefeitura de São Leopoldo e
/// CNES, conferidas em novembro de 2026 (detalhes em
/// docs/fontes/servicos_saude_sao_leopoldo.md). Os telefones locais usam a
/// numeração 2200-07xx publicada pela Prefeitura.
library;

const dataConferenciaServicos = 'novembro de 2026';

enum GrupoServico { ubs, especializado, conversarAgora, emergencia }

class Servico {
  const Servico({
    required this.nome,
    required this.grupo,
    required this.descricao,
    this.endereco,
    this.horario,
    this.telefone,
    this.telefoneExibido,
    this.whatsapp,
    this.site,
    this.destaque = false,
  });

  final String nome;
  final GrupoServico grupo;
  final String descricao;

  /// Endereço como a Prefeitura escreve; também usado na busca do mapa.
  final String? endereco;
  final String? horario;

  /// Número para discar, só dígitos (ex.: "5122000768" ou "188").
  final String? telefone;
  final String? telefoneExibido;

  /// Número do WhatsApp com DDI, só dígitos.
  final String? whatsapp;
  final String? site;

  /// Serviço principal do bairro, mostrado em evidência.
  final bool destaque;
}

const servicos = [
  Servico(
    nome: 'UBS Vila Nova',
    grupo: GrupoServico.ubs,
    destaque: true,
    descricao:
        'Posto de saúde de referência para a maior parte do bairro '
        'Campestre. Também atende saúde mental, de graça.',
    endereco: 'Avenida Alta Tensão, esquina com Rua Armação, 490 – Campestre',
    horario:
        'Segunda a sexta, das 8h às 12h e das 13h às 17h. '
        'Às terças, fecha às 15h.',
    telefone: '5122000768',
    telefoneExibido: '(51) 2200-0768',
  ),
  Servico(
    nome: 'UBS São Cristóvão',
    grupo: GrupoServico.ubs,
    descricao: 'Posto de saúde para quem mora no lado da Vila São Cristóvão.',
    endereco: 'Rua Celestina Maria José de Souza, 37 – São Cristóvão',
    horario:
        'Segunda a sexta, das 8h às 12h e das 13h às 17h. '
        'Às quintas, fecha às 15h.',
    telefone: '5122000795',
    telefoneExibido: '(51) 2200-0795',
  ),
  Servico(
    nome: 'Zap da Saúde São Léo',
    grupo: GrupoServico.ubs,
    descricao:
        'WhatsApp da Secretaria de Saúde. Dá orientações em saúde '
        'mental e ajuda a descobrir qual é a sua UBS.',
    whatsapp: '5551995578541',
    telefoneExibido: '(51) 99557-8541',
  ),
  Servico(
    nome: 'CAPS Capilé',
    grupo: GrupoServico.especializado,
    descricao:
        'Centro de Atenção Psicossocial para adultos com sofrimento '
        'psíquico intenso. Não precisa marcar para o primeiro acolhimento.',
    endereco: 'Rua Bento Gonçalves, 891 – Centro',
    horario: 'Segunda a sexta, em horário comercial. Confirme por telefone.',
    telefone: '5122000761',
    telefoneExibido: '(51) 2200-0761',
  ),
  Servico(
    nome: 'CVV – Centro de Valorização da Vida',
    grupo: GrupoServico.conversarAgora,
    descricao:
        'Apoio emocional e prevenção do suicídio. Ligação gratuita, '
        '24 horas por dia. Também atende por chat no site.',
    telefone: '188',
    telefoneExibido: '188',
    site: 'https://cvv.org.br',
  ),
  Servico(
    nome: 'SAMU',
    grupo: GrupoServico.emergencia,
    descricao:
        'Emergências, inclusive crises de saúde mental. Ligação '
        'gratuita, 24 horas por dia.',
    telefone: '192',
    telefoneExibido: '192',
  ),
  Servico(
    nome: 'Pronto-Socorro do Hospital Centenário',
    grupo: GrupoServico.emergencia,
    descricao: 'Emergência 24 horas, inclusive para crises de saúde mental.',
    endereco: 'Rua Theodomiro Porto da Fonseca, 799 – Fião',
    telefone: '5135911400',
    telefoneExibido: '(51) 3591-1400',
  ),
];

Servico servicoPorNome(String nome) =>
    servicos.firstWhere((s) => s.nome == nome);

const tituloDoGrupo = {
  GrupoServico.ubs: 'Perto de você',
  GrupoServico.especializado: 'Atendimento especializado',
  GrupoServico.conversarAgora: 'Para conversar agora',
  GrupoServico.emergencia: 'Emergência',
};

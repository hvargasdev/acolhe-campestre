import 'package:flutter/material.dart';

import '../dados/servicos.dart';
import '../tema.dart';
import '../util/abrir.dart';

class CartaoServico extends StatelessWidget {
  const CartaoServico({super.key, required this.servico});

  final Servico servico;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final s = servico;

    final acoes = <Widget>[
      if (s.telefone != null)
        FilledButton.icon(
          onPressed: () => ligar(context, s.telefone!),
          icon: const Icon(Icons.call),
          label: Text('Ligar', semanticsLabel: 'Ligar para ${s.nome}'),
        ),
      if (s.whatsapp != null)
        FilledButton.icon(
          onPressed: () => abrirWhatsapp(context, s.whatsapp!),
          icon: const Icon(Icons.chat),
          label: Text(
            'WhatsApp',
            semanticsLabel: 'Abrir WhatsApp do ${s.nome}',
          ),
        ),
      if (s.endereco != null)
        OutlinedButton.icon(
          onPressed: () => abrirMapa(context, s.endereco!),
          icon: const Icon(Icons.map_outlined),
          label: Text('Mapa', semanticsLabel: 'Ver ${s.nome} no mapa'),
        ),
      if (s.site != null)
        OutlinedButton.icon(
          onPressed: () => abrirSite(context, s.site!),
          icon: const Icon(Icons.open_in_new),
          label: Text('Chat', semanticsLabel: 'Abrir o chat do ${s.nome}'),
        ),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: s.destaque ? 2 : 0,
      color: s.destaque
          ? tema.colorScheme.primaryContainer.withValues(alpha: 0.35)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: s.destaque ? corPrincipal : tema.colorScheme.outlineVariant,
          width: s.destaque ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.destaque)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: corPrincipal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Comece por aqui',
                  style: tema.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            Semantics(
              header: true,
              child: Text(s.nome, style: tema.textTheme.titleLarge),
            ),
            const SizedBox(height: 4),
            Text(s.descricao, style: tema.textTheme.bodyLarge),
            if (s.endereco != null)
              _Linha(icone: Icons.place_outlined, texto: s.endereco!),
            if (s.horario != null)
              _Linha(icone: Icons.schedule_outlined, texto: s.horario!),
            if (s.telefoneExibido != null)
              _Linha(
                icone: s.whatsapp != null
                    ? Icons.chat_outlined
                    : Icons.phone_outlined,
                texto: s.telefoneExibido!,
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < acoes.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: acoes[i]),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  const _Linha({required this.icone, required this.texto});

  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(icone, size: 22, color: tema.colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(texto, style: tema.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

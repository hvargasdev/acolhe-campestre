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

    return Card(
      elevation: s.destaque ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: s.destaque
            ? const BorderSide(color: corPrincipal, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.destaque)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Comece por aqui',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: corPrincipal,
                  ),
                ),
              ),
            Semantics(
              header: true,
              child: Text(s.nome, style: tema.textTheme.titleLarge),
            ),
            const SizedBox(height: 6),
            Text(s.descricao, style: tema.textTheme.bodyLarge),
            if (s.endereco != null) ...[
              const SizedBox(height: 8),
              _Linha(icone: Icons.place_outlined, texto: s.endereco!),
            ],
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (s.telefone != null)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 52),
                    ),
                    onPressed: () => ligar(context, s.telefone!),
                    icon: const Icon(Icons.call),
                    label: Text(
                      'Ligar ${s.telefoneExibido}',
                      semanticsLabel: 'Ligar para ${s.nome}',
                    ),
                  ),
                if (s.whatsapp != null)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 52),
                    ),
                    onPressed: () => abrirWhatsapp(context, s.whatsapp!),
                    icon: const Icon(Icons.chat),
                    label: const Text('Abrir WhatsApp'),
                  ),
                if (s.endereco != null)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(140, 52),
                    ),
                    onPressed: () => abrirMapa(context, s.endereco!),
                    icon: const Icon(Icons.map_outlined),
                    label: Text(
                      'Ver no mapa',
                      semanticsLabel: 'Ver ${s.nome} no mapa',
                    ),
                  ),
                if (s.site != null)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(140, 52),
                    ),
                    onPressed: () => abrirSite(context, s.site!),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Abrir site'),
                  ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(child: Icon(icone, size: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

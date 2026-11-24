import 'package:acolhe_campestre/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> abrirApp(WidgetTester tester, {bool termoJaAceito = true}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    AcolheCampestreApp(
      termoJaAceito: termoJaAceito,
      aoAceitarTermo: () async {},
    ),
  );
}

Future<void> responder(WidgetTester tester, String opcao, int vezes) async {
  for (var i = 0; i < vezes; i++) {
    await tester.tap(find.text(opcao));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('termo aparece na primeira vez e leva ao início', (tester) async {
    await abrirApp(tester, termoJaAceito: false);
    expect(find.text('Boas-vindas ao Acolhe Campestre'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Entendi, quero continuar'), 300);
    await tester.tap(find.text('Entendi, quero continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Como você tem se sentido?'), findsOneWidget);
  });

  testWidgets('GAD-7 sem sinais mostra faixa mínima', (tester) async {
    await abrirApp(tester);
    await tester.tap(find.text('Como está minha ansiedade?'));
    await tester.pumpAndSettle();

    expect(find.text('Pergunta 1 de 7'), findsOneWidget);
    await responder(tester, 'Nenhuma vez', 7);

    expect(find.text('Mínima'), findsOneWidget);
    expect(find.text('0 de 21 pontos no GAD-7'), findsOneWidget);
  });

  testWidgets('voltar no questionário desfaz a última resposta', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.tap(find.text('Como está meu humor?'));
    await tester.pumpAndSettle();
    await responder(tester, 'Vários dias', 2);
    expect(find.text('Pergunta 3 de 9'), findsOneWidget);

    await tester.tap(find.byTooltip('Pergunta anterior'));
    await tester.pumpAndSettle();
    expect(find.text('Pergunta 2 de 9'), findsOneWidget);
  });

  testWidgets(
    'pergunta 9 acima de zero abre o apoio imediato antes do resultado',
    (tester) async {
      await abrirApp(tester);
      await tester.tap(find.text('Como está meu humor?'));
      await tester.pumpAndSettle();

      await responder(tester, 'Nenhuma vez', 8);
      await responder(tester, 'Vários dias', 1);

      expect(find.text('Você não está sozinho/a'), findsOneWidget);
      expect(find.text('Ligar 188'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Ver meu resultado'), 300);
      await tester.tap(find.text('Ver meu resultado'));
      await tester.pumpAndSettle();
      expect(find.text('1 de 27 pontos no PHQ-9'), findsOneWidget);
    },
  );
}

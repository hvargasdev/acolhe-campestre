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

Future<void> tocar(WidgetTester tester, Finder alvo) async {
  await tester.scrollUntilVisible(alvo, 300);
  // garante o alvo inteiro na tela (o scrollUntilVisible para quando ele
  // mal aparece na borda, e o toque cairia fora)
  await tester.ensureVisible(alvo);
  await tester.pumpAndSettle();
  await tester.tap(alvo);
  // cobre a pausa de 250 ms depois de escolher uma opção
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
}

Future<void> responder(WidgetTester tester, String opcao, int vezes) async {
  for (var i = 0; i < vezes; i++) {
    await tocar(tester, find.text(opcao));
  }
}

Matcher selecionada(bool sim) => isSemantics(isSelected: sim);

void main() {
  testWidgets('termo aparece na primeira vez e leva ao início', (tester) async {
    await abrirApp(tester, termoJaAceito: false);
    expect(find.text('Boas-vindas ao Acolhe Campestre'), findsOneWidget);

    await tocar(tester, find.text('Entendi, quero continuar'));
    expect(find.text('Como você tem se sentido?'), findsOneWidget);
  });

  testWidgets('GAD-7 sem sinais passa pela revisão e mostra faixa mínima', (
    tester,
  ) async {
    await abrirApp(tester);
    await tocar(tester, find.text('Como está minha ansiedade?'));

    expect(find.text('Pergunta 1 de 7'), findsOneWidget);
    await responder(tester, 'Nenhuma vez', 7);

    expect(find.text('Confira suas respostas'), findsOneWidget);
    await tocar(tester, find.text('Ver resultado'));

    expect(find.text('Mínima'), findsOneWidget);
    expect(find.text('0 de 21 pontos no GAD-7'), findsOneWidget);
  });

  testWidgets('voltar mostra a pergunta anterior com a resposta marcada', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await abrirApp(tester);
    await tocar(tester, find.text('Como está meu humor?'));
    await responder(tester, 'Vários dias', 2);
    expect(find.text('Pergunta 3 de 9'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Pergunta 2 de 9'), findsOneWidget);
    expect(tester.getSemantics(find.text('Vários dias')), selecionada(true));
    expect(tester.getSemantics(find.text('Nenhuma vez')), selecionada(false));
    semantica.dispose();
  });

  testWidgets('na revisão, alterar uma resposta muda o resultado', (
    tester,
  ) async {
    await abrirApp(tester);
    await tocar(tester, find.text('Como está minha ansiedade?'));
    await responder(tester, 'Nenhuma vez', 7);

    // muda a pergunta 1 para "Quase todos os dias" (3 pontos)
    await tocar(
      tester,
      find.text('Sentir-se nervoso/a, ansioso/a ou muito tenso/a'),
    );
    expect(find.text('Pergunta 1 de 7'), findsOneWidget);
    await tocar(tester, find.text('Quase todos os dias'));

    expect(find.text('Confira suas respostas'), findsOneWidget);
    await tocar(tester, find.text('Ver resultado'));
    expect(find.text('3 de 21 pontos no GAD-7'), findsOneWidget);
  });

  testWidgets('sair no meio pede confirmação', (tester) async {
    await abrirApp(tester);
    await tocar(tester, find.text('Como está meu humor?'));
    await responder(tester, 'Vários dias', 1);
    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sair'));
    await tester.pumpAndSettle();

    expect(find.text('Sair do questionário?'), findsOneWidget);
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(find.text('Como você tem se sentido?'), findsOneWidget);
  });

  testWidgets(
    'pergunta 9 acima de zero abre o apoio imediato antes do resultado',
    (tester) async {
      await abrirApp(tester);
      await tocar(tester, find.text('Como está meu humor?'));

      await responder(tester, 'Nenhuma vez', 8);
      await responder(tester, 'Vários dias', 1);
      await tocar(tester, find.text('Ver resultado'));

      expect(find.text('Você não está sozinho/a'), findsOneWidget);
      expect(find.text('CVV – Centro de Valorização da Vida'), findsOneWidget);

      await tocar(tester, find.text('Ver meu resultado'));
      expect(find.text('1 de 27 pontos no PHQ-9'), findsOneWidget);
    },
  );
}

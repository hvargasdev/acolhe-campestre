import 'package:acolhe_campestre/dados/questionarios.dart';
import 'package:acolhe_campestre/modelos/questionario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PHQ-9', () {
    test('tem 9 itens e pontuação máxima 27', () {
      expect(phq9.itens.length, 9);
      expect(phq9.pontuacaoMaxima, 27);
    });

    test('faixas cobrem de 0 a 27 sem buraco nem sobreposição', () {
      for (var p = 0; p <= 27; p++) {
        expect(
          phq9.faixas.where((f) => f.contem(p)).length,
          1,
          reason: 'pontuação $p',
        );
      }
    });

    test('pontos de corte 5, 10, 15 e 20', () {
      String faixaDe(int pontos) {
        // distribui os pontos pelos 8 primeiros itens, deixando o 9º em zero
        final respostas = List.filled(9, 0);
        var resto = pontos;
        for (var i = 0; i < 8 && resto > 0; i++) {
          respostas[i] = resto >= 3 ? 3 : resto;
          resto -= respostas[i];
        }
        return phq9.calcular(respostas).faixa.nome;
      }

      expect(faixaDe(4), 'Mínima');
      expect(faixaDe(5), 'Leve');
      expect(faixaDe(9), 'Leve');
      expect(faixaDe(10), 'Moderada');
      expect(faixaDe(15), 'Moderadamente grave');
      expect(faixaDe(20), 'Grave');
      expect(faixaDe(24), 'Grave');
    });

    test(
      'pergunta 9 acima de zero pede apoio imediato, mesmo com total baixo',
      () {
        final r = phq9.calcular([0, 0, 0, 0, 0, 0, 0, 0, 1]);
        expect(r.pontuacao, 1);
        expect(r.faixa.nivel, NivelAtencao.minimo);
        expect(r.precisaApoioImediato, isTrue);
      },
    );

    test('pergunta 9 em zero não pede apoio imediato', () {
      final r = phq9.calcular([3, 3, 3, 3, 3, 3, 3, 3, 0]);
      expect(r.precisaApoioImediato, isFalse);
      expect(r.faixa.nome, 'Grave');
    });
  });

  group('GAD-7', () {
    test('tem 7 itens e pontuação máxima 21', () {
      expect(gad7.itens.length, 7);
      expect(gad7.pontuacaoMaxima, 21);
    });

    test('faixas cobrem de 0 a 21 e cortes em 5, 10 e 15', () {
      for (var p = 0; p <= 21; p++) {
        expect(
          gad7.faixas.where((f) => f.contem(p)).length,
          1,
          reason: 'pontuação $p',
        );
      }
      expect(gad7.calcular([1, 1, 1, 1, 0, 0, 0]).faixa.nome, 'Mínima');
      expect(gad7.calcular([1, 1, 1, 1, 1, 0, 0]).faixa.nome, 'Leve');
      expect(gad7.calcular([2, 2, 2, 2, 2, 0, 0]).faixa.nome, 'Moderada');
      expect(gad7.calcular([3, 3, 3, 3, 3, 0, 0]).faixa.nome, 'Grave');
    });

    test('nunca pede apoio imediato (não tem item de risco)', () {
      expect(gad7.calcular(List.filled(7, 3)).precisaApoioImediato, isFalse);
    });
  });

  test('rejeita quantidade errada de respostas ou valor inválido', () {
    expect(() => gad7.calcular([0, 0]), throwsArgumentError);
    expect(() => gad7.calcular([0, 0, 0, 0, 0, 0, 4]), throwsArgumentError);
  });
}

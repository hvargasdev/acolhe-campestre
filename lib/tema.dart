import 'package:flutter/material.dart';

import 'modelos/questionario.dart';

/// Verde-azulado escuro: calmo e com bom contraste sobre fundo claro.
const corPrincipal = Color(0xFF1F6F63);

/// Laranja escuro para alertas de apoio imediato (contraste AA com branco).
const corAlerta = Color(0xFFB3261E);

ThemeData criarTema() {
  final esquema = ColorScheme.fromSeed(seedColor: corPrincipal);
  final base = ThemeData(colorScheme: esquema, useMaterial3: true);
  // Textos um pouco maiores que o padrão; o tamanho de fonte escolhido no
  // celular continua sendo respeitado (Desenho Universal).
  // O textTheme do ThemeData vem sem tamanhos; eles ficam na tipografia.
  final texto = Typography.englishLike2021
      .merge(base.textTheme)
      .apply(fontSizeFactor: 1.1);

  return base.copyWith(
    textTheme: texto,
    appBarTheme: AppBarTheme(
      backgroundColor: corPrincipal,
      foregroundColor: Colors.white,
      titleTextStyle: texto.titleLarge?.copyWith(color: Colors.white),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        textStyle: texto.titleMedium,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        textStyle: texto.titleMedium,
        side: const BorderSide(color: corPrincipal, width: 1.5),
      ),
    ),
  );
}

Color corDoNivel(NivelAtencao nivel) => switch (nivel) {
  NivelAtencao.minimo => const Color(0xFF2E7D32),
  NivelAtencao.leve => const Color(0xFF6D6A00),
  NivelAtencao.moderado => const Color(0xFFB45309),
  NivelAtencao.alto => corAlerta,
};

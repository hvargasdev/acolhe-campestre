import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tema.dart';
import 'telas/inicio_tela.dart';
import 'telas/termo_tela.dart';

/// Única informação gravada no celular: se o termo de uso já foi aceito.
/// As respostas dos questionários nunca são salvas.
const _chaveTermoAceito = 'termo_aceito';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    AcolheCampestreApp(
      termoJaAceito: prefs.getBool(_chaveTermoAceito) ?? false,
      aoAceitarTermo: () => prefs.setBool(_chaveTermoAceito, true),
    ),
  );
}

class AcolheCampestreApp extends StatefulWidget {
  const AcolheCampestreApp({
    super.key,
    required this.termoJaAceito,
    required this.aoAceitarTermo,
  });

  final bool termoJaAceito;
  final Future<void> Function() aoAceitarTermo;

  @override
  State<AcolheCampestreApp> createState() => _AcolheCampestreAppState();
}

class _AcolheCampestreAppState extends State<AcolheCampestreApp> {
  late bool _termoAceito = widget.termoJaAceito;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acolhe Campestre',
      debugShowCheckedModeBanner: false,
      theme: criarTema(),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: _termoAceito
          ? const InicioTela()
          : TermoTela(
              aoAceitar: () {
                widget.aoAceitarTermo();
                setState(() => _termoAceito = true);
              },
            ),
    );
  }
}

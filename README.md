# Acolhe Campestre

Aplicativo Android, feito em Flutter (Dart), que ajuda moradores do bairro Campestre, em São Leopoldo/RS, a reconhecer sinais de ansiedade e depressão e a encontrar atendimento gratuito em saúde mental.

Projeto da Atividade Extensionista II – Tecnologia Aplicada à Inclusão Digital (CST em Desenvolvimento Mobile – UNINTER).

## O que o app faz

- Aplica os questionários de uso livre PHQ-9 (humor) e GAD-7 (ansiedade).
- Mostra a faixa de resultado e orienta o morador a procurar o serviço mais adequado: a UBS do bairro, o CAPS de São Leopoldo ou o CVV (188).
- Se a pessoa indicar pensamentos de morte ou de se ferir, mostra na hora os contatos de apoio imediato (CVV 188 e SAMU 192).

O aplicativo **não faz diagnóstico**. Não tem cadastro, e as respostas ficam salvas só no celular, em respeito à LGPD.

## Como executar

Requer o Flutter 3.44.5 (versão fixada em `.fvmrc`).

```bash
flutter pub get
flutter run                 # celular Android conectado
flutter build apk --release # gera o APK para instalar
```

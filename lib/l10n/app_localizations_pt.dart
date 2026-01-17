// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Sistema Oksigenia pronto.';

  @override
  String get statusConnecting => 'Conectando satélites...';

  @override
  String get statusSent => 'Alerta enviado com sucesso.';

  @override
  String statusError(Object error) {
    return 'ERRO: $error';
  }

  @override
  String get menuWeb => 'Site Oficial';

  @override
  String get menuSupport => 'Suporte Técnico';

  @override
  String get menuLanguages => 'Idioma';

  @override
  String get menuSettings => 'Configurações';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ALERTA OKSIGENIA* 🆘\n\nPreciso de ajuda urgente.\n📍 Localização: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Configurações SOS';

  @override
  String get settingsLabel => 'Telefone de Emergência';

  @override
  String get settingsHint => 'Ex: +351 91 234 5678';

  @override
  String get settingsSave => 'SALVAR';

  @override
  String get settingsSavedMsg => 'Contato salvo com sucesso';

  @override
  String get errorNoContact => '⚠️ Configure um contato primeiro!';

  @override
  String get autoModeLabel => 'Detecção de Queda';

  @override
  String get autoModeDescription => 'Monitora impactos fortes.';

  @override
  String get alertFallDetected => 'IMPACTO DETECTADO!';

  @override
  String get alertFallBody => 'Queda grave detectada. Você está bem?';
}

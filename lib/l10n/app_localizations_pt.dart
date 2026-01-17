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

  @override
  String get disclaimerTitle => '⚠️ AVISO LEGAL E PRIVACIDADE';

  @override
  String get disclaimerText =>
      'Este aplicativo é uma ferramenta de apoio e NÃO substitui os serviços de emergência profissionais (112, 911).\n\nPRIVACIDADE: Oksigenia NÃO coleta dados pessoais. Sua localização e contatos permanecem exclusivamente no seu dispositivo.\n\nO funcionamento depende do estado do dispositivo, bateria e cobertura. Use por sua conta e risco.';

  @override
  String get btnAccept => 'ACEITAR';

  @override
  String get btnDecline => 'SAIR';

  @override
  String get menuPrivacy => 'Privacidade e Legal';

  @override
  String get privacyTitle => 'Termos e Privacidade';

  @override
  String get privacyPolicyContent =>
      'POLÍTICA DE PRIVACIDADE E TERMOS DE USO\n\n1. SEM COLETA DE DADOS\nOksigenia SOS foi projetado com privacidade desde a conceção. O aplicativo opera inteiramente de forma local. Não enviamos seus dados para nenhuma nuvem, não usamos servidores de rastreamento e não vendemos suas informações. Seus contatos de emergência permanecem estritamente no seu dispositivo.\n\n2. USO DE PERMISSÕES\n- Localização: Usada estritamente para obter coordenadas GPS em caso de impacto ou ativação manual. Nenhum rastreamento em segundo plano ocorre quando o monitoramento está desativado.\n- SMS: Usado exclusivamente para enviar a mensagem de alerta ao seu contato definido. O aplicativo não lê suas mensagens pessoais.\n\n3. LIMITAÇÃO DE RESPONSABILIDADE\nEste aplicativo é fornecido \'como está\', sem garantia de qualquer tipo. A Oksigenia e seus desenvolvedores não são responsáveis por danos ou consequências resultantes de falhas no software, incluindo: falta de cobertura celular, bateria descarregada ou erros de GPS.\n\nEsta ferramenta é um complemento de segurança e nunca deve ser considerada um substituto infalível para serviços de emergência profissionais.';
}

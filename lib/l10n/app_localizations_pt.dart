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
  String get statusReady => 'Sistema Oksigenia Pronto.';

  @override
  String get statusConnecting => 'Conectando satélites...';

  @override
  String get statusLocationFixed => 'LOCALIZAÇÃO FIXADA';

  @override
  String get statusSent => 'Alerta enviado com sucesso.';

  @override
  String get alarmSendingNow => 'Enviando alerta…';

  @override
  String get alarmSendFailed => 'SOS NÃO ENVIADO';

  @override
  String get btnRetry => 'Tentar novamente';

  @override
  String get statusSendFailed => '⚠️ SOS NÃO ENVIADO';

  @override
  String get statusSendFailedBody =>
      'Não foi possível enviar nenhum SMS. Verifique a cobertura e os contactos e tente novamente.';

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
  String get menuPrivacy => 'Privacidade e Legal';

  @override
  String get menuDonate => 'Donar / Donate';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ALERTA OKSIGENIA* 🆘\n\nPreciso de ajuda urgente.\n📍 Localização: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Configuração SOS';

  @override
  String get settingsLabel => 'Telefone de Emergência';

  @override
  String get settingsHint => 'Ex: +351 912 345 678';

  @override
  String get settingsSave => 'GUARDAR';

  @override
  String get settingsSavedMsg => 'Contacto guardado corretamente';

  @override
  String get errorNoContact => '⚠️ Configure um contacto primeiro!';

  @override
  String get autoModeLabel => 'Deteção de Quedas';

  @override
  String get autoModeDescription => 'Monitoriza impactos severos.';

  @override
  String get inactivityModeLabel => 'Monitor de Inatividade';

  @override
  String get inactivityModeDescription =>
      'Alerta si não for detectado movimento.';

  @override
  String get alertFallDetected => 'IMPACTO DETETADO!';

  @override
  String get alertFallBody => 'Queda severa detetada. Estás bem?';

  @override
  String get alertInactivityDetected => 'INATIVIDADE DETETADA!';

  @override
  String get alertInactivityBody => 'Sem movimento detetado. Estás bem?';

  @override
  String get btnImOkay => 'ESTOU BEM';

  @override
  String get disclaimerTitle => '⚠️ AVISO LEGAL E PRIVACIDADE';

  @override
  String get disclaimerText =>
      'Oksigenia SOS é uma ferramenta de apoio, não um substituto para serviços de emergência profissionais. O seu funcionamento depende de fatores externos: bateria, sinal GPS e cobertura móvel.\n\nAo activar esta aplicação, aceita que o software é fornecido \'tal como está\' e isenta os programadores de responsabilidade legal por falhas técnicas. Você é responsável pela sua própria segurança.\n\nCustos do serviço SMS: Todos os custos de mensagens são da responsabilidade del utilizador, de acordo com as tarifas do seu operador móvel. A Oksigenia não cobre nem cobra por estas mensagens.';

  @override
  String get btnAccept => 'ACEITO O RISCO';

  @override
  String get btnDecline => 'SAIR';

  @override
  String get privacyTitle => 'Termos e Privacidade';

  @override
  String get privacyPolicyContent =>
      'POLÍTICA DE PRIVACIDADE E TERMOS\n\n1. SEM COLETA DE DADOS\nOksigenia SOS funciona localmente. Não enviamos dados para a nuvem nem vendemos as suas informações.\n\n2. PERMISSÕES\n- Localização: Para coordenadas em caso de alerta.\n- SMS: Exclusivamente para enviar a mensagem de socorro.\n\n3. LIMITAÇÃO DE RESPONSABILIDADE\nA aplicação é entregue \'tal como está\'. Não nos responsabilizamos por falhas de cobertura ou hardware.';

  @override
  String get advSettingsTitle => 'Funções Avançadas';

  @override
  String get advSettingsSubtitle => 'Multi-contacto, Rastreio GPS...';

  @override
  String get dialogCommunityTitle => '💎 Comunidade Oksigenia';

  @override
  String get dialogCommunityBody => 'Versão COMMUNITY (Grátis).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody => 'Subscreva o PRO.';

  @override
  String get btnDonate => 'Ofereça-me um café ☕';

  @override
  String get btnSubscribe => 'Subscrever';

  @override
  String get btnClose => 'Fechar';

  @override
  String get permSmsTitle => 'PERIGO! Permissão SMS bloqueada';

  @override
  String get permSmsBody => 'A aplicação NÃO pode enviar alertas.';

  @override
  String get permSmsButton => 'Ativar SMS';

  @override
  String get restrictedSettingsTitle => 'Definições Restritas';

  @override
  String get restrictedSettingsBody => 'O Android restringiu esta permissão.';

  @override
  String get contactsTitle => 'Contactos de Emergência';

  @override
  String get contactsSubtitle => 'O primeiro recebe o rastreio GPS.';

  @override
  String get contactsAddHint => 'Novo número';

  @override
  String get contactsEmpty => '⚠️ Sem contactos.';

  @override
  String get messageTitle => 'Mensagem Personalizada';

  @override
  String get messageSubtitle => 'Enviada ANTES das coordenadas.';

  @override
  String get messageHint => 'Ex : Diabético. Rota Norte...';

  @override
  String get trackingTitle => 'Rastreio GPS';

  @override
  String get trackingSubtitle => 'Envia posição a intervalos.';

  @override
  String get trackOff => '❌ Desactivado';

  @override
  String get track30 => '⏱️ A cada 30 min';

  @override
  String get track60 => '⏱️ A cada 1 hora';

  @override
  String get track120 => '⏱️ A cada 2 horas';

  @override
  String get inactivityTimeTitle => 'Tempo para Alerta';

  @override
  String get inactivityTimeSubtitle => 'Quanto tempo sem movimento?';

  @override
  String get ina30s => '🧪 30 seg';

  @override
  String get ina1h => '⏱️ 1 hora';

  @override
  String get ina2h => '⏱️ 2 horas';

  @override
  String get testModeWarning => 'MODO TEST ATIVO: 30s.';

  @override
  String get toastHoldToSOS => 'Segure para SOS';

  @override
  String get donateDialogTitle => '💎 Apoie o Projeto';

  @override
  String get donateDialogBody => 'Pague-nos um café.';

  @override
  String get donateBtn => 'Doar via PayPal';

  @override
  String get donateClose => 'FECHAR';

  @override
  String get alertSendingIn => 'A enviar alerta em...';

  @override
  String get alertCancel => 'CANCELAR';

  @override
  String get warningKeepAlive =>
      '⚠️ IMPORTANTE: Não feche a aplicação deslizando o dedo (Gestor de Tarefas). Deixe-a em segundo plano para que possa reiniciar automaticamente.';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get aboutVersion => 'Versão';

  @override
  String get aboutDisclaimer => 'Aviso Legal';

  @override
  String get aboutPrivacy => 'Política de Privacidade';

  @override
  String get aboutSourceCode => 'Código-fonte (GitHub)';

  @override
  String get aboutLicenses => 'Licenças de Software';

  @override
  String get aboutDevelopedBy => 'Desenvolvido com ❤️ por Oksigenia';

  @override
  String get dialogClose => 'Fechar';

  @override
  String get permSmsText =>
      'Permissões SMS em falta. Não é possível enviar alertas.';

  @override
  String get phoneLabel => 'Telefone (ex: +351...)';

  @override
  String get btnAdd => 'ADICIONAR';

  @override
  String get noContacts => 'Nenhum contato configurado.';

  @override
  String get inactivityTitle => 'Tempo de Inatividade';

  @override
  String get invalidNumberWarning => 'Número inválido ou muito curto';

  @override
  String get contactMain => 'Principal (Rastreio / Bateria)';

  @override
  String get inactivitySubtitle => 'Tempo sem movimento antes de pedir ajuda.';

  @override
  String get dialogPermissionTitle => 'Como ativar permissões';

  @override
  String get dialogPermissionStep1 =>
      '1. Toque em \'IR PARA DEFINIÇÕES\' abaixo.';

  @override
  String get dialogPermissionStep2 =>
      '2. No novo ecrã, toque nos 3 pontos (⠇) no canto superior direito.';

  @override
  String get dialogPermissionStep3 =>
      '3. Selecione \'Permitir definições restritas\' (se visível).';

  @override
  String get dialogPermissionStep4 => '4. Volte a esta aplicação.';

  @override
  String get btnGoToSettings => 'IR PARA DEFINIÇÕES';

  @override
  String get timerLabel => 'Temporizador';

  @override
  String get timerSeconds => 'seg';

  @override
  String get permSmsOk => 'Permissão SMS ativa';

  @override
  String get permSensorsOk => 'Sensores ativos';

  @override
  String get permNotifOk => 'Notificações ativas';

  @override
  String get permSmsMissing => 'Falta permissão SMS';

  @override
  String get permSensorsMissing => 'Faltam sensores';

  @override
  String get permNotifMissing => 'Faltam notificações';

  @override
  String get permOverlayMissing => 'Falta sobreposição';

  @override
  String get permDialogTitle => 'Permissão Necessária';

  @override
  String get permSmsHelpTitle => 'Ajuda SMS';

  @override
  String get permGoSettings => 'Ir para Configurações';

  @override
  String get gpsHelpTitle => 'Sobre o GPS';

  @override
  String get gpsHelpBody =>
      'A precisão depende do chip físico do seu telemóvel e da visão direta do céu.\n\nEm interiores, garagens ou túneis, o sinal de satélite é bloqueado e a localização pode ser aproximada ou nula.\n\nOksigenia tentará sempre triangular a melhor posição possível.';

  @override
  String get holdToCancel => 'Segure para cancelar';

  @override
  String get statusMonitorStopped => 'Monitor parado.';

  @override
  String get statusScreenSleep => 'Ecrã a desligar...';

  @override
  String get btnRestartSystem => 'REINICIAR SISTEMA';

  @override
  String get smsDyingGasp => 'BATERIA <5%. A desligar sistema. Loc:';

  @override
  String get smsHelpMessage => 'AJUDA! Preciso de assistência urgente.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - acompanhamento (NÃO é um novo alarme):';

  @override
  String get batteryDialogTitle => 'Restrição de Bateria';

  @override
  String get btnDisableBatterySaver => 'DESATIVAR POUPANÇA';

  @override
  String get batteryDialogBody =>
      'O sistema restringe a bateria desta app. Para o SOS funcionar em segundo plano, selecione \'Sem restrições\' ou \'Não otimizar\'.';

  @override
  String get permBgLocationTitle => 'GPS em segundo plano';

  @override
  String get bgLocationDialogBody =>
      'Quando o alarme dispara, o telemóvel costuma estar no bolso com o ecrã apagado. Para que o SOS saia com a tua posição exata nesse momento, o Android exige a localização em modo «Permitir sempre».\n\nA tua localização nunca sai do telemóvel: nem internet, nem nuvem, nem rastreadores — viaja apenas dentro do SMS de SOS para os teus próprios contactos.\n\nNo ecrã seguinte, escolhe «Permitir sempre».';

  @override
  String get whyPermsBgLocation =>
      'Obtém a tua posição GPS com o ecrã apagado ou a app em segundo plano — exatamente quando um SOS dispara. A localização só é enviada dentro do SMS de SOS para os teus contactos; nunca sai do telemóvel de outra forma.';

  @override
  String get btnEnableBgLocation => 'Permitir sempre';

  @override
  String get permLocMissing => 'Falta Permissão Localização';

  @override
  String get slideStopSystem => 'DESLIZE P/ PARAR';

  @override
  String get onboardingTitle => 'Configurar o seu sistema de segurança';

  @override
  String get onboardingSubtitle =>
      'Estas permissões são essenciais para que o Oksigenia SOS o proteja no terreno.';

  @override
  String get onboardingGrant => 'CONCEDER';

  @override
  String get onboardingGranted => 'CONCEDIDO ✓';

  @override
  String get onboardingNext => 'CONTINUAR';

  @override
  String get onboardingFinish => 'PRONTO — INICIAR MONITORIZAÇÃO';

  @override
  String get onboardingMandatory => 'Necessário para ativar a monitorização';

  @override
  String get onboardingSkip => 'Ignorar';

  @override
  String get fullScreenIntentTitle => 'Alarme no Ecrã Bloqueado';

  @override
  String get fullScreenIntentBody =>
      'Permite que o alarme apareça sobre o ecrã bloqueado. Sem isto, o alarme soa mas o ecrã não acende. No Android 14+: Definições → Apps → Oksigenia SOS → Notificações em ecrã completo.';

  @override
  String get btnEnableFullScreenIntent => 'ATIVAR';

  @override
  String get pauseMonitoringSheet => 'Pausar monitorização por...';

  @override
  String get pauseTitle => 'Monitorização pausada';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Pausado · retoma em $time';
  }

  @override
  String get pauseResumeNow => 'Retomar agora';

  @override
  String get pauseResumedMsg => 'Monitorização retomada';

  @override
  String get pauseHoldHint => 'Segure para pausar';

  @override
  String get pauseSec5 => '5 segundos';

  @override
  String get liveTrackingTitle => 'Rastreamento ao Vivo';

  @override
  String get liveTrackingSubtitle =>
      'Envia a sua posição GPS por SMS em intervalos regulares.';

  @override
  String get liveTrackingInterval => 'Intervalo de envio';

  @override
  String get liveTrackingShutdownReminder => 'Lembrete de desligamento';

  @override
  String get liveTrackingNoReminder => '❌ Sem lembrete';

  @override
  String get liveTrackingReminder2h => '⏰ Após 2 horas';

  @override
  String get liveTrackingReminder3h => '⏰ Após 3 horas';

  @override
  String get liveTrackingReminder4h => '⏰ Após 4 horas';

  @override
  String get liveTrackingReminder5h => '⏰ Após 5 horas';

  @override
  String get liveTrackingLegalTitle => '⚠️ Custos de SMS';

  @override
  String get liveTrackingLegalBody =>
      'O Rastreamento ao Vivo envia um SMS por intervalo ao seu contacto principal. As tarifas do seu operador aplicam-se. É o único responsável por todos os custos de mensagens.';

  @override
  String get liveTrackingActivate => 'ATIVAR RASTREAMENTO';

  @override
  String get liveTrackingDeactivate => 'DESATIVAR';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Próxima atualização em $time';
  }

  @override
  String get liveTrackingCardTitle => 'Rastreamento ao Vivo Ativo';

  @override
  String get liveTrackingPausedSOS => 'Pausado — SOS ativo';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TESTE)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TESTE)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'MODO TESTE: Rastreamento enviará a cada $time.';
  }

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get whyPermsTitle => 'Por que essas permissões?';

  @override
  String get whyPermsSms =>
      'Envia alertas de emergência por SMS aos seus contatos. Funciona sem internet.';

  @override
  String get whyPermsLocation =>
      'Inclui coordenadas GPS no alerta para que os socorristas saibam exatamente onde você está.';

  @override
  String get whyPermsNotifications =>
      'Mostra o status de monitoramento e permite cancelar um alarme falso da tela de bloqueio.';

  @override
  String get whyPermsActivity =>
      'Detecta padrões de movimento para evitar falsos alarmes ao caminhar ou correr.';

  @override
  String get whyPermsSensors =>
      'Lê o acelerômetro para detectar a força G de uma queda.';

  @override
  String get whyPermsBattery =>
      'Impede que o Android encerre o app durante o monitoramento em segundo plano.';

  @override
  String get whyPermsFullScreen =>
      'Mostra o alarme sobre a tela de bloqueio para que você possa responder sem desbloquear.';

  @override
  String get sentinelGreen => 'Sistema ativo';

  @override
  String get sentinelYellow => 'Impacto detetado · a analisar...';

  @override
  String get sentinelOrange => 'Alerta iminente!';

  @override
  String get sentinelRed => 'ALARME ATIVO';

  @override
  String get activityProfileTitle => 'Perfil de atividade';

  @override
  String get activityProfileSubtitle =>
      'Ajusta a deteção do Smart Sentinel ao teu desporto. Escolhe o mais próximo — um perfil errado provoca falsos alarmes ou perde quedas reais.';

  @override
  String get profileTrekking => 'Trekking / Caminhada';

  @override
  String get profileTrekkingDesc =>
      'Predefinição. Caminhar ao ar livre com o telemóvel no bolso ou mochila. Sensibilidade equilibrada.';

  @override
  String get profileRunning => 'Corrida (estrada)';

  @override
  String get profileRunningDesc =>
      'Corrida em asfalto ou pavimento duro. Limiar de impacto mais elevado (10G) e detetor de cadência adaptativo — gere o regime sustentado de força horizontal da corrida que quebra o detetor de cadência padrão.';

  @override
  String get profileTrailMtb => 'Trail / BTT';

  @override
  String get profileTrailMtbDesc =>
      'Limite de impacto mais alto e cadência mais permissiva — a vibração constante em terreno irregular provocaria falsos alarmes com a configuração padrão.';

  @override
  String get profileMountaineering => 'Alpinismo';

  @override
  String get profileMountaineeringDesc =>
      'Mesma base do trekking com janela de observação alargada a 90 segundos, para recuperações lentas em terreno técnico.';

  @override
  String get profileParagliding => 'Parapente';

  @override
  String get profileParaglidingDesc =>
      'A deteção automática de quedas está DESATIVADA — o acelerómetro não consegue distinguir manobras de voo de uma queda real. SOS manual e monitor de inatividade continuam ativos.';

  @override
  String get profileKayak => 'Caiaque / Desportos aquáticos';

  @override
  String get profileKayakDesc =>
      'A deteção automática de quedas está DESATIVADA — a água amortece os impactos e o movimento de flutuação não é informativo. Usa o monitor de inatividade e o SOS manual.';

  @override
  String get profileEquitation => 'Equitação';

  @override
  String get profileEquitationDesc =>
      'A deteção automática de quedas está DESATIVADA — a cadência do cavalo (trote, galope) interfere com o detetor de marcha humana. O monitor de inatividade e o SOS manual protegem-te durante a montaria.';

  @override
  String get profileProfessional => 'Profissional / Resgate';

  @override
  String get profileProfessionalDesc =>
      'Janela de observação alargada a 120 segundos para uso operacional avançado onde a recuperação após uma queda pode exceder os tempos padrão.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Impacto ${imp}G · Observ ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Impacto OFF · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'DESARMADO — toque num interruptor abaixo para ativar';

  @override
  String get homeAlertSensorPermDenied => 'Permissão de sensores negada';

  @override
  String get homeConfirmTitleImpact => 'Deteção de impactos';

  @override
  String get homeConfirmTitleObservation => 'Observação';

  @override
  String get homeConfirmTitleGps => 'Intervalo GPS';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'ON · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'OFF';

  @override
  String get homeProfileNoFallWarning =>
      'Este perfil NÃO deteta quedas. O SOS deve ser ativado manualmente.';

  @override
  String get homeActionApply => 'Aplicar';

  @override
  String get smsBeaconDistance => 'do ponto do SOS.';

  @override
  String get homeBeaconBanner =>
      'A enviar a tua localização ao contacto após o SOS — toca para parar';

  @override
  String get beaconStopped => 'Avisos de movimento parados';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Sistema Oksigenia Listo.';

  @override
  String get statusConnecting => 'Conectando satélites...';

  @override
  String get statusLocationFixed => 'UBICACIÓN FIJADA';

  @override
  String get statusSent => 'Alerta enviada con éxito.';

  @override
  String get alarmSendingNow => 'Enviando alerta…';

  @override
  String get alarmSendFailed => 'SOS NO ENVIADO';

  @override
  String get btnRetry => 'Reintentar';

  @override
  String get statusSendFailed => '⚠️ SOS NO ENVIADO';

  @override
  String get statusSendFailedBody =>
      'No se pudo enviar ningún SMS. Comprueba cobertura y contactos, y reintenta.';

  @override
  String statusError(Object error) {
    return 'ERROR: $error';
  }

  @override
  String get menuWeb => 'Sitio Web';

  @override
  String get menuSupport => 'Soporte Técnico';

  @override
  String get menuLanguages => 'Idioma';

  @override
  String get menuSettings => 'Ajustes';

  @override
  String get menuPrivacy => 'Privacidad y Legal';

  @override
  String get menuDonate => 'Donar';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ALERTA OKSIGENIA* 🆘\n\nNecesito ayuda urgente.\n📍 Ubicación: $link';
  }

  @override
  String get settingsTitle => 'Configuración SOS';

  @override
  String get settingsLabel => 'Contacto Emergencia';

  @override
  String get settingsHint => 'Ej: +34 600 123 456';

  @override
  String get settingsSave => 'GUARDAR';

  @override
  String get settingsSavedMsg => 'Contacto guardado correctamente';

  @override
  String get errorNoContact => '⚠️ ¡Configura un contacto primero!';

  @override
  String get autoModeLabel => 'Detectar Caídas';

  @override
  String get autoModeDescription => 'Monitoriza impactos severos.';

  @override
  String get inactivityModeLabel => 'Monitor de Inactividad';

  @override
  String get inactivityModeDescription => 'Alerta si no se detecta movimiento.';

  @override
  String get alertFallDetected => '¡IMPACTO DETECTADO!';

  @override
  String get alertFallBody => 'Caída severa detectada. ¿Estás bien?';

  @override
  String get alertInactivityDetected => '¡INACTIVIDAD DETECTADA!';

  @override
  String get alertInactivityBody => 'Sin movimiento detectado. ¿Estás bien?';

  @override
  String get btnImOkay => 'ESTOY BIEN';

  @override
  String get disclaimerTitle => '⚠️ AVISO LEGAL Y PRIVACIDAD';

  @override
  String get disclaimerText =>
      'Oksigenia SOS es una herramienta de apoyo, no un sustituto de los servicios de emergencia profesionales. Su funcionamiento depende de factores externos: batería, señal GPS y cobertura móvil.\n\nAl activar esta aplicación, usted acepta que el software se proporciona \'tal cual\' y libera a los desarrolladores de responsabilidad legal por fallos técnicos. Usted es responsable de su propia seguridad.\n\nCostes de SMS: Todos los costes de mensajería son responsabilidad del usuario según las tarifas de su operador móvil. Oksigenia no cubre ni cobra por estos mensajes.';

  @override
  String get btnAccept => 'ACEPTO EL RIESGO';

  @override
  String get btnDecline => 'SALIR';

  @override
  String get privacyTitle => 'Términos y Privacidad';

  @override
  String get privacyPolicyContent =>
      'POLÍTICA DE PRIVACIDAD Y TÉRMINOS\n\n1. SIN RECOLECCIÓN DE DATOS\nOksigenia SOS funciona localmente. No subimos datos a la nube ni vendemos tu información.\n\n2. PERMISOS\n- Ubicación: Para coordenadas en caso de alerta.\n- SMS: Exclusivamente para enviar el mensaje de socorro.\n\n3. LIMITACIÓN DE RESPONSABILIDAD\nApp entregada \'tal cual\'. No nos hacemos responsables por fallos de cobertura o hardware.';

  @override
  String get advSettingsTitle => 'Funciones Avanzadas';

  @override
  String get advSettingsSubtitle => 'Multi-contacto, Rastreo GPS...';

  @override
  String get dialogCommunityTitle => '💎 Comunidad Oksigenia';

  @override
  String get dialogCommunityBody =>
      'Esta es la versión COMMUNITY (Gratis).\n\nTodas las funciones están desbloqueadas gracias al código abierto.';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Suscríbete a PRO para desbloquear múltiples contactos y rastreo en tiempo real.';

  @override
  String get btnDonate => 'Invítame a un café ☕';

  @override
  String get btnSubscribe => 'Suscribirse';

  @override
  String get btnClose => 'Cerrar';

  @override
  String get permSmsTitle => '¡PELIGRO! Permiso SMS bloqueado';

  @override
  String get permSmsBody =>
      'La app NO podrá enviar alertas aunque tengas contactos.';

  @override
  String get permSmsButton => 'Activar SMS en Ajustes';

  @override
  String get restrictedSettingsTitle => 'Ajustes Restringidos';

  @override
  String get restrictedSettingsBody =>
      'Android ha restringido este permiso porque la aplicación se instaló manualmente (side-loaded).';

  @override
  String get contactsTitle => 'Contactos de Emergencia';

  @override
  String get contactsSubtitle => 'El primero recibirá el seguimiento GPS.';

  @override
  String get contactsAddHint => 'Nuevo número';

  @override
  String get contactsEmpty => '⚠️ Sin contactos. La alerta no saldrá.';

  @override
  String get messageTitle => 'Mensaje Personalizado';

  @override
  String get messageSubtitle => 'Se enviará ANTES de las coordenadas.';

  @override
  String get messageHint => 'Ej: Soy diabético. Ruta Norte...';

  @override
  String get trackingTitle => 'Seguimiento GPS';

  @override
  String get trackingSubtitle => 'Envía posición al Principal cada X tiempo.';

  @override
  String get trackOff => '❌ Desactivado';

  @override
  String get track30 => '⏱️ Cada 30 min';

  @override
  String get track60 => '⏱️ Cada 1 hora';

  @override
  String get track120 => '⏱️ Cada 2 horas';

  @override
  String get inactivityTimeTitle => 'Tiempo para Alerta';

  @override
  String get inactivityTimeSubtitle =>
      '¿Cuánto tiempo sin moverte antes de avisar?';

  @override
  String get ina30s => '🧪 30 seg (Modo TEST)';

  @override
  String get ina1h => '⏱️ 1 hora (Recomendado)';

  @override
  String get ina2h => '⏱️ 2 horas (Pausa larga)';

  @override
  String get testModeWarning => 'MODO TEST: La alerta saltará en 30s.';

  @override
  String get toastHoldToSOS => 'Mantén pulsado para SOS';

  @override
  String get donateDialogTitle => '💎 Apoya el Proyecto';

  @override
  String get donateDialogBody =>
      'Esta app es Software Libre y Gratuito. Si te da seguridad, invítanos a un café para mantener los servidores.';

  @override
  String get donateBtn => 'Donar con PayPal';

  @override
  String get donateClose => 'CERRAR';

  @override
  String get alertSendingIn => 'Enviando alerta en...';

  @override
  String get alertCancel => 'CANCELAR';

  @override
  String get warningKeepAlive =>
      '⚠️ IMPORTANTE: No cierres la app deslizando (Multitarea). Déjala en 2º plano para que reinicie sola si apagas el móvil.';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutVersion => 'Versión';

  @override
  String get aboutDisclaimer => 'Aviso Legal';

  @override
  String get aboutPrivacy => 'Política de Privacidad';

  @override
  String get aboutSourceCode => 'Código Fuente (GitHub)';

  @override
  String get aboutLicenses => 'Licencias de Software';

  @override
  String get aboutDevelopedBy => 'Desarrollado con ❤️ por Oksigenia';

  @override
  String get dialogClose => 'Cerrar';

  @override
  String get permSmsText =>
      'Faltan permisos de SMS. La app no podrá enviar alertas.';

  @override
  String get phoneLabel => 'Teléfono (ej: +34...)';

  @override
  String get btnAdd => 'AÑADIR';

  @override
  String get noContacts => 'No hay contactos configurados.';

  @override
  String get inactivityTitle => 'Tiempo de Inactividad';

  @override
  String get invalidNumberWarning => 'Número inválido o muy corto';

  @override
  String get contactMain => 'Principal (Tracking / Batería)';

  @override
  String get inactivitySubtitle =>
      'Tiempo sin movimiento antes de pedir ayuda.';

  @override
  String get dialogPermissionTitle => 'Cómo activar el permiso';

  @override
  String get dialogPermissionStep1 => '1. Toca \'IR A AJUSTES\' abajo.';

  @override
  String get dialogPermissionStep2 =>
      '2. En la nueva pantalla, toca los 3 puntos (⠇) arriba a la derecha.';

  @override
  String get dialogPermissionStep3 =>
      '3. Selecciona \'Permitir ajustes restringidos\' (si aparece).';

  @override
  String get dialogPermissionStep4 => '4. Vuelve a esta app.';

  @override
  String get btnGoToSettings => 'IR A AJUSTES';

  @override
  String get timerLabel => 'Temporizador';

  @override
  String get timerSeconds => 'seg';

  @override
  String get permSmsOk => 'Permiso SMS activo';

  @override
  String get permSensorsOk => 'Sensores activos';

  @override
  String get permNotifOk => 'Notificaciones activas';

  @override
  String get permSmsMissing => 'Falta permiso SMS';

  @override
  String get permSensorsMissing => 'Faltan sensores';

  @override
  String get permNotifMissing => 'Faltan notificaciones';

  @override
  String get permOverlayMissing => 'Falta permiso superposición';

  @override
  String get permDialogTitle => 'Permiso Requerido';

  @override
  String get permSmsHelpTitle => 'Ayuda SMS';

  @override
  String get permGoSettings => 'Ir a Ajustes';

  @override
  String get gpsHelpTitle => 'Sobre el GPS';

  @override
  String get gpsHelpBody =>
      'La precisión depende del chip físico de tu móvil y de tener visión directa del cielo.\n\nEn interiores, garajes o túneles, la señal de los satélites no entra y la ubicación puede ser aproximada o nula.\n\nOksigenia siempre intentará triangular la mejor posición posible.';

  @override
  String get holdToCancel => 'Mantén pulsado para cancelar';

  @override
  String get statusMonitorStopped => 'Monitor detenido.';

  @override
  String get statusScreenSleep => 'Apagando pantalla...';

  @override
  String get btnRestartSystem => 'REINICIAR SISTEMA';

  @override
  String get smsDyingGasp => 'BATERIA <5%. Me apago. Loc:';

  @override
  String get smsHelpMessage => '¡AYUDA! Necesito asistencia.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - seguimiento (NO es alarma nueva):';

  @override
  String get batteryDialogTitle => 'Restricción de Batería';

  @override
  String get btnDisableBatterySaver => 'DESACTIVAR AHORRO';

  @override
  String get batteryDialogBody =>
      'El sistema está restringiendo la batería de esta app. Para que SOS funcione en segundo plano, debes seleccionar \'Sin Restricciones\' o \'No Optimizar\'.';

  @override
  String get permBgLocationTitle => 'GPS en segundo plano';

  @override
  String get bgLocationDialogBody =>
      'Cuando la alarma salta, el móvil suele estar en el bolsillo con la pantalla apagada. Para que el SOS salga con tu posición exacta en ese momento, Android necesita la ubicación en modo «Permitir siempre».\n\nTu ubicación nunca sale del teléfono: ni internet, ni nube, ni rastreadores — sólo viaja dentro del SMS de SOS a tus propios contactos.\n\nEn la siguiente pantalla, elige «Permitir siempre».';

  @override
  String get whyPermsBgLocation =>
      'Obtiene tu posición GPS con la pantalla apagada o la app en segundo plano — justo cuando salta un SOS. La ubicación sólo se envía dentro del SMS de SOS a tus contactos; nunca sale del teléfono por otra vía.';

  @override
  String get btnEnableBgLocation => 'Permitir siempre';

  @override
  String get permLocMissing => 'Falta Permiso de Ubicación';

  @override
  String get slideStopSystem => 'DESLIZA PARA APAGAR';

  @override
  String get onboardingTitle => 'Configura tu sistema de seguridad';

  @override
  String get onboardingSubtitle =>
      'Estos permisos son esenciales para que Oksigenia SOS pueda protegerte en el campo.';

  @override
  String get onboardingGrant => 'CONCEDER';

  @override
  String get onboardingGranted => 'CONCEDIDO ✓';

  @override
  String get onboardingNext => 'CONTINUAR';

  @override
  String get onboardingFinish => 'LISTO — INICIAR MONITORIZACIÓN';

  @override
  String get onboardingMandatory => 'Necesario para activar la monitorización';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get fullScreenIntentTitle => 'Alarma en Pantalla Bloqueada';

  @override
  String get fullScreenIntentBody =>
      'Permite que la alarma aparezca sobre la pantalla bloqueada. Sin esto, la alarma suena pero la pantalla no se enciende. En Android 14+: Ajustes → Apps → Oksigenia SOS → Notificaciones en pantalla completa.';

  @override
  String get btnEnableFullScreenIntent => 'ACTIVAR';

  @override
  String get pauseMonitoringSheet => 'Pausar monitorización durante...';

  @override
  String get pauseTitle => 'Monitorización pausada';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Pausado · $time restantes';
  }

  @override
  String get pauseResumeNow => 'Reanudar ahora';

  @override
  String get pauseResumedMsg => 'Monitorización reanudada';

  @override
  String get pauseHoldHint => 'Mantén para pausar';

  @override
  String get pauseSec5 => '5 segundos';

  @override
  String get liveTrackingTitle => 'Seguimiento en Vivo';

  @override
  String get liveTrackingSubtitle =>
      'Envía tu posición GPS por SMS a intervalos regulares.';

  @override
  String get liveTrackingInterval => 'Intervalo de envío';

  @override
  String get liveTrackingShutdownReminder => 'Recordatorio de apagado';

  @override
  String get liveTrackingNoReminder => '❌ Sin recordatorio';

  @override
  String get liveTrackingReminder2h => '⏰ A las 2 horas';

  @override
  String get liveTrackingReminder3h => '⏰ A las 3 horas';

  @override
  String get liveTrackingReminder4h => '⏰ A las 4 horas';

  @override
  String get liveTrackingReminder5h => '⏰ A las 5 horas';

  @override
  String get liveTrackingLegalTitle => '⚠️ Costes de SMS';

  @override
  String get liveTrackingLegalBody =>
      'El Seguimiento Vivo envía un SMS por intervalo a tu contacto principal. Se aplican las tarifas de tu operador. Eres el único responsable de los costes de mensajería.';

  @override
  String get liveTrackingActivate => 'ACTIVAR SEGUIMIENTO';

  @override
  String get liveTrackingDeactivate => 'DESACTIVAR';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Próximo envío en $time';
  }

  @override
  String get liveTrackingCardTitle => 'Seguimiento en Vivo Activo';

  @override
  String get liveTrackingPausedSOS => 'Pausado — SOS activo';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'MODO TEST: Live Tracking enviará cada $time.';
  }

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get whyPermsTitle => '¿Por qué estos permisos?';

  @override
  String get whyPermsSms =>
      'Envía alertas de emergencia por SMS a tus contactos. Funciona sin internet.';

  @override
  String get whyPermsLocation =>
      'Incluye coordenadas GPS en la alerta para que los rescatistas sepan exactamente dónde estás.';

  @override
  String get whyPermsNotifications =>
      'Muestra el estado de monitorización y permite cancelar una falsa alarma desde la pantalla de bloqueo.';

  @override
  String get whyPermsActivity =>
      'Detecta patrones de movimiento para evitar falsas alarmas al caminar o correr.';

  @override
  String get whyPermsSensors =>
      'Lee el acelerómetro para detectar la fuerza G de una caída.';

  @override
  String get whyPermsBattery =>
      'Evita que Android cierre la app mientras monitoriza en segundo plano.';

  @override
  String get whyPermsFullScreen =>
      'Muestra la alarma sobre la pantalla de bloqueo para que puedas responder sin desbloquear.';

  @override
  String get sentinelGreen => 'Sistema activo';

  @override
  String get sentinelYellow => 'Impacto detectado · analizando...';

  @override
  String get sentinelOrange => '¡Alerta inminente!';

  @override
  String get sentinelRed => 'ALARMA ACTIVA';

  @override
  String get activityProfileTitle => 'Perfil de actividad';

  @override
  String get activityProfileSubtitle =>
      'Ajusta la detección del Smart Sentinel a tu deporte. Elige el más parecido — un perfil incorrecto provoca falsas alarmas o pierde caídas reales.';

  @override
  String get profileTrekking => 'Trekking / Senderismo';

  @override
  String get profileTrekkingDesc =>
      'Por defecto. Caminar al aire libre con el móvil en bolsillo o mochila. Sensibilidad equilibrada.';

  @override
  String get profileRunning => 'Running (asfalto)';

  @override
  String get profileRunningDesc =>
      'Correr en asfalto o pavimento duro. Umbral de impacto más alto (10G) y detector de cadencia adaptativo — gestiona el régimen sostenido de fuerza horizontal del running que rompe el detector de cadencia estándar.';

  @override
  String get profileTrailMtb => 'Trail / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Umbral de impacto más alto y cadencia más permisiva — la vibración constante en terreno irregular generaría falsas alarmas con la configuración estándar.';

  @override
  String get profileMountaineering => 'Alpinismo';

  @override
  String get profileMountaineeringDesc =>
      'Misma base que trekking con ventana de observación ampliada a 90 segundos, para recuperaciones lentas en terreno técnico.';

  @override
  String get profileParagliding => 'Parapente';

  @override
  String get profileParaglidingDesc =>
      'La detección automática de caídas está DESACTIVADA — el acelerómetro no puede distinguir maniobras de vuelo de una caída real. SOS manual y monitor de inactividad siguen activos.';

  @override
  String get profileKayak => 'Kayak / Deportes acuáticos';

  @override
  String get profileKayakDesc =>
      'La detección automática de caídas está DESACTIVADA — el agua amortigua los impactos y el movimiento de flotación no es informativo. Usa el monitor de inactividad y el SOS manual.';

  @override
  String get profileEquitation => 'Equitación';

  @override
  String get profileEquitationDesc =>
      'La detección automática de caídas está DESACTIVADA — el ritmo del caballo (trote, galope) interfiere con el detector de marcha humana. El monitor de inactividad y el SOS manual te protegen durante la ruta.';

  @override
  String get profileProfessional => 'Profesional / Rescate';

  @override
  String get profileProfessionalDesc =>
      'Ventana de observación ampliada a 120 segundos para uso operativo avanzado donde la recuperación tras una caída puede superar los tiempos estándar.';

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
      'SIN ARMAR — pulsa un interruptor abajo para activar';

  @override
  String get homeAlertSensorPermDenied => 'Permiso de sensores denegado';

  @override
  String get homeConfirmTitleImpact => 'Detección de impactos';

  @override
  String get homeConfirmTitleObservation => 'Observación';

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
      'Este perfil NO detecta caídas. El SOS debe activarse manualmente.';

  @override
  String get homeActionApply => 'Aplicar';

  @override
  String get smsBeaconDistance => 'desde el punto del SOS.';

  @override
  String get homeBeaconBanner =>
      'Enviando tu ubicación al contacto tras el SOS — toca para detener';

  @override
  String get beaconStopped => 'Avisos de movimiento detenidos';
}

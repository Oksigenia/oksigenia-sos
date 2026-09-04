// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Système Oksigenia Prêt.';

  @override
  String get statusConnecting => 'Connexion satellites...';

  @override
  String get statusLocationFixed => 'POSITION FIXÉE';

  @override
  String get statusSent => 'Alerte envoyée avec succès.';

  @override
  String get alarmSendingNow => 'Envoi de l\'alerte…';

  @override
  String get alarmSendFailed => 'SOS NON ENVOYÉ';

  @override
  String get btnRetry => 'Réessayer';

  @override
  String get statusSendFailed => '⚠️ SOS NON ENVOYÉ';

  @override
  String get statusSendFailedBody =>
      'Aucun SMS n\'a pu être envoyé. Vérifiez la couverture et les contacts, puis réessayez.';

  @override
  String statusError(Object error) {
    return 'ERREUR : $error';
  }

  @override
  String get menuWeb => 'Site Officiel';

  @override
  String get menuSupport => 'Support Technique';

  @override
  String get menuLanguages => 'Langue';

  @override
  String get menuSettings => 'Paramètres';

  @override
  String get menuPrivacy => 'Confidentialité et Légal';

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
    return '🆘 *ALERTE OKSIGENIA* 🆘\n\nBesoin d\'aide urgente.\n📍 Position : $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Configuration SOS';

  @override
  String get settingsLabel => 'Téléphone d\'Urgence';

  @override
  String get settingsHint => 'Ex : +33 6 12 34 56 78';

  @override
  String get settingsSave => 'ENREGISTRER';

  @override
  String get settingsSavedMsg => 'Contact enregistré correctement';

  @override
  String get errorNoContact => '⚠️ Configurez d\'abord un contact !';

  @override
  String get autoModeLabel => 'Détection de Chute';

  @override
  String get autoModeDescription => 'Surveille les impacts sévères.';

  @override
  String get inactivityModeLabel => 'Moniteur d\'Inactivité';

  @override
  String get inactivityModeDescription =>
      'Alerte si aucun mouvement n\'est détecté.';

  @override
  String get alertFallDetected => 'IMPACT DÉTECTÉ !';

  @override
  String get alertFallBody => 'Chute sévère détectée. Ça va ?';

  @override
  String get alertInactivityDetected => 'INACTIVITÉ DÉTECTÉE !';

  @override
  String get alertInactivityBody => 'Aucun mouvement détecté. Ça va ?';

  @override
  String get btnImOkay => 'JE VAIS BIEN';

  @override
  String get disclaimerTitle => '⚠️ AVIS JURIDIQUE ET CONFIDENTIALITÉ';

  @override
  String get disclaimerText =>
      'Oksigenia SOS est un outil de soutien et non un substitut aux services d\'urgence professionnels. Son fonctionnement dépend de facteurs externes : batterie, signal GPS et couverture mobile.\n\nEn activant cette application, vous acceptez que le logiciel soit fourni \'en l\'état\' et dégagez les développeurs de toute responsabilité légale en cas de défaillances techniques. Vous êtes responsable de votre propre sécurité.\n\nFrais de service SMS : Tous les coûts de messagerie sont à la charge de l\'utilisateur selon les tarifs de son opérateur mobile. Oksigenia ne couvre ni ne facture ces messages.';

  @override
  String get btnAccept => 'J\'ACCEPTE LE RISQUE';

  @override
  String get btnDecline => 'QUITTER';

  @override
  String get privacyTitle => 'Conditions et Confidentialité';

  @override
  String get privacyPolicyContent =>
      'POLITIQUE DE CONFIDENTIALITÉ ET CONDITIONS\n\n1. AUCUNE COLLECTE DE DONNÉES\nOksigenia SOS fonctionne localement. Nous ne téléchargeons aucune donnée sur le cloud et ne vendons pas vos informations.\n\n2. PERMISSIONS\n- Localisation : Pour les coordonnées en cas d\'alerte.\n- SMS : Exclusivement pour envoyer le message de détresse.\n\n3. LIMITATION DE RESPONSABILITÉ\nL\'application est fournie \'telle quelle\'. Nous ne sommes pas responsables des pannes de réseau ou de matériel.';

  @override
  String get advSettingsTitle => 'Fonctions Avancées';

  @override
  String get advSettingsSubtitle => 'Multi-contacts, Suivi GPS...';

  @override
  String get dialogCommunityTitle => '💎 Communauté Oksigenia';

  @override
  String get dialogCommunityBody => 'Version COMMUNITY (Gratuit).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Abonnez-vous à PRO pour le suivi en temps réel.';

  @override
  String get btnDonate => 'Offrez-moi un café ☕';

  @override
  String get btnSubscribe => 'S\'abonner';

  @override
  String get btnClose => 'Fermer';

  @override
  String get permSmsTitle => 'DANGER ! Permission SMS bloquée';

  @override
  String get permSmsBody => 'L\'app NE PEUT PAS envoyer d\'alertes.';

  @override
  String get permSmsButton => 'Activer SMS';

  @override
  String get restrictedSettingsTitle => 'Paramètres Restreints';

  @override
  String get restrictedSettingsBody =>
      'Android a restreint cette autorisation.';

  @override
  String get contactsTitle => 'Contacts d\'Urgence';

  @override
  String get contactsSubtitle => 'Le premier reçoit le suivi GPS.';

  @override
  String get contactsAddHint => 'Nouveau numéro';

  @override
  String get contactsEmpty => '⚠️ Aucun contact.';

  @override
  String get messageTitle => 'Message Personnalisé';

  @override
  String get messageSubtitle => 'Envoyé AVANT les coordonnées.';

  @override
  String get messageHint => 'Ex : Diabétique. Route Nord...';

  @override
  String get trackingTitle => 'Suivi GPS';

  @override
  String get trackingSubtitle => 'Envoie la position à intervalles.';

  @override
  String get trackOff => '❌ Désactivé';

  @override
  String get track30 => '⏱️ Toutes les 30 min';

  @override
  String get track60 => '⏱️ Toutes les 1 h';

  @override
  String get track120 => '⏱️ Toutes les 2 h';

  @override
  String get inactivityTimeTitle => 'Délai avant Alerte';

  @override
  String get inactivityTimeSubtitle => 'Temps sans mouvement ?';

  @override
  String get ina30s => '🧪 30 sec';

  @override
  String get ina1h => '⏱️ 1 heure';

  @override
  String get ina2h => '⏱️ 2 heures';

  @override
  String get testModeWarning => 'MODE TEST ACTIVÉ : 30s.';

  @override
  String get toastHoldToSOS => 'Maintenez pour SOS';

  @override
  String get donateDialogTitle => '💎 Soutenez-nous';

  @override
  String get donateDialogBody => 'Offrez-nous un café.';

  @override
  String get donateBtn => 'Faire un don PayPal';

  @override
  String get donateClose => 'FERMER';

  @override
  String get alertSendingIn => 'Envoi d\'une alerte...';

  @override
  String get alertCancel => 'ANNULER';

  @override
  String get warningKeepAlive =>
      '⚠️ IMPORTANT : Ne fermez pas l\'application (Gestionnaire de tâches) en la faisant glisser. Laissez-la en arrière-plan pour qu\'elle puisse redémarrer automatiquement.';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutDisclaimer => 'Mentions légales';

  @override
  String get aboutPrivacy => 'Politique de confidentialité';

  @override
  String get aboutSourceCode => 'Code source (GitHub)';

  @override
  String get aboutLicenses => 'Licences logicielles';

  @override
  String get aboutDevelopedBy => 'Développé avec ❤️ par Oksigenia';

  @override
  String get dialogClose => 'Fermer';

  @override
  String get permSmsText =>
      'Permissions SMS manquantes. Impossible d\'envoyer des alertes.';

  @override
  String get phoneLabel => 'Téléphone (ex: +33...)';

  @override
  String get btnAdd => 'AJOUTER';

  @override
  String get noContacts => 'Aucun contact configuré.';

  @override
  String get inactivityTitle => 'Temps d\'inactivité';

  @override
  String get invalidNumberWarning => 'Numéro invalide ou trop court';

  @override
  String get contactMain => 'Principal (Suivi / Batterie)';

  @override
  String get inactivitySubtitle =>
      'Temps sans mouvement avant l\'appel à l\'aide.';

  @override
  String get dialogPermissionTitle => 'Comment activer les permissions';

  @override
  String get dialogPermissionStep1 =>
      '1. Touchez \'ALLER AUX PARAMÈTRES\' ci-dessous.';

  @override
  String get dialogPermissionStep2 =>
      '2. Sur le nouvel écran, touchez les 3 points (⠇) en haut à droite.';

  @override
  String get dialogPermissionStep3 =>
      '3. Sélectionnez \'Autoriser les paramètres restreints\' (si visible).';

  @override
  String get dialogPermissionStep4 => '4. Revenez à cette application.';

  @override
  String get btnGoToSettings => 'ALLER AUX PARAMÈTRES';

  @override
  String get timerLabel => 'Minuteur';

  @override
  String get timerSeconds => 's';

  @override
  String get permSmsOk => 'Permission SMS active';

  @override
  String get permSensorsOk => 'Capteurs actifs';

  @override
  String get permNotifOk => 'Notifications actives';

  @override
  String get permSmsMissing => 'Permission SMS manquante';

  @override
  String get permSensorsMissing => 'Capteurs manquants';

  @override
  String get permNotifMissing => 'Notifications manquantes';

  @override
  String get permOverlayMissing => 'Superposition manquante';

  @override
  String get permDialogTitle => 'Permission Requise';

  @override
  String get permSmsHelpTitle => 'Aide SMS';

  @override
  String get permGoSettings => 'Aller aux Paramètres';

  @override
  String get gpsHelpTitle => 'À propos du GPS';

  @override
  String get gpsHelpBody =>
      'La précision dépend de la puce physique de votre téléphone et d\'une vue directe sur le ciel.\n\nÀ l\'intérieur, dans les garages ou les tunnels, le signal satellite ne passe pas et la localisation peut être approximative ou nulle.\n\nOksigenia essaiera toujours de trianguler la meilleure position possible.';

  @override
  String get holdToCancel => 'Maintenir pour annuler';

  @override
  String get statusMonitorStopped => 'Surveillance arrêtée.';

  @override
  String get statusScreenSleep => 'Extinction de l\'écran...';

  @override
  String get btnRestartSystem => 'REDÉMARRER SYSTÈME';

  @override
  String get smsDyingGasp => 'BATTERIE <5%. Extinction. Loc:';

  @override
  String get smsHelpMessage => 'À L\'AIDE ! J\'ai besoin d\'assistance.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - suivi (PAS une nouvelle alarme):';

  @override
  String get batteryDialogTitle => 'Restriction Batterie';

  @override
  String get btnDisableBatterySaver => 'DÉSACTIVER ÉCO';

  @override
  String get batteryDialogBody =>
      'Le système restreint la batterie de cette application. Pour que le SOS fonctionne en arrière-plan, vous devez sélectionner « Non restreint » ou « Ne pas optimiser ».';

  @override
  String get permBgLocationTitle => 'GPS en arrière-plan';

  @override
  String get bgLocationDialogBody =>
      'Quand l\'alarme se déclenche, le téléphone est généralement dans la poche, écran éteint. Pour que le SOS parte avec votre position exacte à cet instant, Android exige le niveau de localisation « Toujours autoriser ».\n\nVotre position ne quitte jamais le téléphone : pas d\'internet, pas de cloud, pas de traceurs — elle ne voyage que dans le SMS de SOS envoyé à vos propres contacts.\n\nSur l\'écran suivant, choisissez « Toujours autoriser ».';

  @override
  String get whyPermsBgLocation =>
      'Obtient votre position GPS quand l\'écran est éteint ou l\'application en arrière-plan — précisément quand un SOS se déclenche. La position n\'est envoyée que dans le SMS de SOS à vos contacts ; elle ne quitte jamais votre téléphone autrement.';

  @override
  String get btnEnableBgLocation => 'Toujours autoriser';

  @override
  String get permLocMissing => 'Permission localisation manquante';

  @override
  String get slideStopSystem => 'GLISSER POUR ARRÊTER';

  @override
  String get onboardingTitle => 'Configurer votre système de sécurité';

  @override
  String get onboardingSubtitle =>
      'Ces permissions sont essentielles pour qu\'Oksigenia SOS puisse vous protéger sur le terrain.';

  @override
  String get onboardingGrant => 'ACCORDER';

  @override
  String get onboardingGranted => 'ACCORDÉ ✓';

  @override
  String get onboardingNext => 'CONTINUER';

  @override
  String get onboardingFinish => 'PRÊT — DÉMARRER LA SURVEILLANCE';

  @override
  String get onboardingMandatory => 'Requis pour activer la surveillance';

  @override
  String get onboardingSkip => 'Ignorer';

  @override
  String get fullScreenIntentTitle => 'Alarme sur écran verrouillé';

  @override
  String get fullScreenIntentBody =>
      'Permet à l\'alarme d\'apparaître sur l\'écran verrouillé. Sans cela, l\'alarme sonne mais l\'écran ne s\'allume pas. Sur Android 14+ : Paramètres → Applications → Oksigenia SOS → Notifications en plein écran.';

  @override
  String get btnEnableFullScreenIntent => 'ACTIVER';

  @override
  String get pauseMonitoringSheet => 'Mettre en pause pour...';

  @override
  String get pauseTitle => 'Surveillance en pause';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ En pause · reprend dans $time';
  }

  @override
  String get pauseResumeNow => 'Reprendre maintenant';

  @override
  String get pauseResumedMsg => 'Surveillance reprise';

  @override
  String get pauseHoldHint => 'Appuyez longuement pour pausar';

  @override
  String get pauseSec5 => '5 secondes';

  @override
  String get liveTrackingTitle => 'Suivi en Direct';

  @override
  String get liveTrackingSubtitle =>
      'Envoie votre position GPS par SMS à intervalles réguliers.';

  @override
  String get liveTrackingInterval => 'Intervalle d\'envoi';

  @override
  String get liveTrackingShutdownReminder => 'Rappel d\'extinction';

  @override
  String get liveTrackingNoReminder => '❌ Pas de rappel';

  @override
  String get liveTrackingReminder2h => '⏰ Après 2 heures';

  @override
  String get liveTrackingReminder3h => '⏰ Après 3 heures';

  @override
  String get liveTrackingReminder4h => '⏰ Après 4 heures';

  @override
  String get liveTrackingReminder5h => '⏰ Après 5 heures';

  @override
  String get liveTrackingLegalTitle => '⚠️ Coûts SMS';

  @override
  String get liveTrackingLegalBody =>
      'Le Suivi en Direct envoie un SMS par intervalle à votre contact principal. Les tarifs de votre opérateur s\'appliquent. Vous êtes seul responsable des coûts de messagerie.';

  @override
  String get liveTrackingActivate => 'ACTIVER LE SUIVI';

  @override
  String get liveTrackingDeactivate => 'DÉSACTIVER';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Prochain envoi dans $time';
  }

  @override
  String get liveTrackingCardTitle => 'Suivi en Direct Actif';

  @override
  String get liveTrackingPausedSOS => 'En pause — SOS actif';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'MODE TEST : Suivi enverra toutes les $time.';
  }

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get whyPermsTitle => 'Pourquoi ces permissions ?';

  @override
  String get whyPermsSms =>
      'Envoie des alertes d\'urgence par SMS à vos contacts. Fonctionne sans internet.';

  @override
  String get whyPermsLocation =>
      'Inclut les coordonnées GPS dans l\'alerte pour que les secours sachent exactement où vous êtes.';

  @override
  String get whyPermsNotifications =>
      'Affiche le statut de surveillance et permet d\'annuler une fausse alarme depuis l\'écran verrouillé.';

  @override
  String get whyPermsActivity =>
      'Détecte les schémas de mouvement pour éviter les fausses alarmes lors de la marche ou de la course.';

  @override
  String get whyPermsSensors =>
      'Lit l\'accéléromètre pour détecter la force G d\'une chute.';

  @override
  String get whyPermsBattery =>
      'Empêche Android de tuer l\'application pendant la surveillance en arrière-plan.';

  @override
  String get whyPermsFullScreen =>
      'Affiche l\'alarme sur l\'écran verrouillé pour répondre sans déverrouiller.';

  @override
  String get sentinelGreen => 'Système actif';

  @override
  String get sentinelYellow => 'Impact détecté · analyse en cours...';

  @override
  String get sentinelOrange => 'Alerte imminente !';

  @override
  String get sentinelRed => 'ALARME ACTIVE';

  @override
  String get activityProfileTitle => 'Profil d\'activité';

  @override
  String get activityProfileSubtitle =>
      'Adapte la détection du Smart Sentinel à votre sport. Choisissez le plus proche — un mauvais profil provoque des fausses alarmes ou rate de vraies chutes.';

  @override
  String get profileTrekking => 'Randonnée';

  @override
  String get profileTrekkingDesc =>
      'Par défaut. Marcher en plein air avec le téléphone en poche ou dans un sac à dos. Sensibilité équilibrée.';

  @override
  String get profileRunning => 'Running (route)';

  @override
  String get profileRunningDesc =>
      'Course sur asphalte ou revêtement dur. Seuil d\'impact plus élevé (10G) et détecteur de cadence adaptatif — gère le régime soutenu de la force horizontale du running qui casse le détecteur de cadence standard.';

  @override
  String get profileTrailMtb => 'Trail / VTT';

  @override
  String get profileTrailMtbDesc =>
      'Seuil d\'impact plus élevé et cadence plus permissive — la vibration constante sur terrain accidenté provoquerait des fausses alarmes avec la configuration standard.';

  @override
  String get profileMountaineering => 'Alpinisme';

  @override
  String get profileMountaineeringDesc =>
      'Même base que la randonnée avec une fenêtre d\'observation étendue à 90 secondes, pour des récupérations lentes en terrain technique.';

  @override
  String get profileParagliding => 'Parapente';

  @override
  String get profileParaglidingDesc =>
      'La détection automatique de chute est DÉSACTIVÉE — l\'accéléromètre ne peut pas distinguer les manœuvres de vol d\'une vraie chute. Le SOS manuel et le moniteur d\'inactivité restent actifs.';

  @override
  String get profileKayak => 'Kayak / Sports nautiques';

  @override
  String get profileKayakDesc =>
      'La détection automatique de chute est DÉSACTIVÉE — l\'eau amortit les impacts et le mouvement de flottaison n\'est pas informatif. Utilisez le moniteur d\'inactivité et le SOS manuel.';

  @override
  String get profileEquitation => 'Équitation';

  @override
  String get profileEquitationDesc =>
      'La détection automatique de chute est DÉSACTIVÉE — la cadence du cheval (trot, galop) interfère avec le détecteur de marche humaine. Le moniteur d\'inactivité et le SOS manuel vous protègent pendant la randonnée.';

  @override
  String get profileProfessional => 'Professionnel / Sauvetage';

  @override
  String get profileProfessionalDesc =>
      'Fenêtre d\'observation étendue à 120 secondes pour un usage opérationnel avancé où la récupération après une chute peut dépasser les délais standards.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Impact ${imp}G · Observ ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Impact OFF · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'NON ARMÉ — touchez un interrupteur ci-dessous pour activer';

  @override
  String get homeAlertSensorPermDenied => 'Permission capteurs refusée';

  @override
  String get homeConfirmTitleImpact => 'Détection d\'impacts';

  @override
  String get homeConfirmTitleObservation => 'Observation';

  @override
  String get homeConfirmTitleGps => 'Intervalle GPS';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'ON · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'OFF';

  @override
  String get homeProfileNoFallWarning =>
      'Ce profil NE détecte PAS les chutes. Le SOS doit être déclenché manuellement.';

  @override
  String get homeActionApply => 'Appliquer';

  @override
  String get smsBeaconDistance => 'du point du SOS.';

  @override
  String get homeBeaconBanner =>
      'Envoi de votre position au contact après le SOS — touchez pour arrêter';

  @override
  String get beaconStopped => 'Alertes de mouvement arrêtées';
}

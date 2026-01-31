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
  String get menuX => 'X (Twitter)';

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
  String get btnGoToSettings => 'ALLER AUX PARAMÈTRES';

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
  String get contactMain => 'Principal (Suivi / Batterie)';

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
  String get testModeWarning => '⚠️ MODE TEST ACTIVÉ : 30s.';

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
  String get timerLabel => 'Minuterie';

  @override
  String get timerSeconds => 'secondes';

  @override
  String get permDialogTitle => 'Vérification';

  @override
  String get permGoSettings => 'PARAMÈTRES';

  @override
  String get permSmsOk => 'Permission SMS active.';

  @override
  String get permSmsMissing =>
      'Nous avons besoin des SMS pour envoyer les alertes d\'urgence à vos contacts.';

  @override
  String get permSensorsOk => 'Capteurs actifs.';

  @override
  String get permSensorsMissing =>
      'Nous avons besoin d\'accès aux Capteurs et à l\'Activité Physique pour détecter les chutes.';

  @override
  String get permNotifOk => 'Notifications actives.';

  @override
  String get permNotifMissing =>
      'Nous avons besoin des Notifications pour maintenir le système actif en arrière-plan.';

  @override
  String get permOverlayMissing =>
      'Requis pour afficher l\'alarme sur d\'autres applis (Telegram, WhatsApp).';
}

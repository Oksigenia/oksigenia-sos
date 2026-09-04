// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'System Oksigenia gotowy.';

  @override
  String get statusConnecting => 'Łączenie z satelitami...';

  @override
  String get statusLocationFixed => 'POZYCJA USTALONA';

  @override
  String get statusSent => 'Alert wysłany pomyślnie.';

  @override
  String get alarmSendingNow => 'Wysyłanie alarmu…';

  @override
  String get alarmSendFailed => 'SOS NIE WYSŁANE';

  @override
  String get btnRetry => 'Spróbuj ponownie';

  @override
  String get statusSendFailed => '⚠️ SOS NIE WYSŁANE';

  @override
  String get statusSendFailedBody =>
      'Nie udało się wysłać żadnego SMS-a. Sprawdź zasięg i kontakty, a następnie spróbuj ponownie.';

  @override
  String statusError(Object error) {
    return 'BŁĄD: $error';
  }

  @override
  String get menuWeb => 'Oficjalna strona';

  @override
  String get menuSupport => 'Wsparcie techniczne';

  @override
  String get menuLanguages => 'Język';

  @override
  String get menuSettings => 'Ustawienia';

  @override
  String get menuPrivacy => 'Prywatność i prawo';

  @override
  String get menuDonate => 'Wesprzyj / Donate';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ALERT OKSIGENIA* 🆘\n\nPotrzebuję pilnej pomocy.\n📍 Lokalizacja: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Ustawienia SOS';

  @override
  String get settingsLabel => 'Telefon alarmowy';

  @override
  String get settingsHint => 'Np: +48 600 123 456';

  @override
  String get settingsSave => 'ZAPISZ';

  @override
  String get settingsSavedMsg => 'Kontakt zapisany pomyślnie';

  @override
  String get errorNoContact => '⚠️ Najpierw skonfiguruj kontakt!';

  @override
  String get autoModeLabel => 'Wykrywanie upadku';

  @override
  String get autoModeDescription => 'Monitoruje silne uderzenia.';

  @override
  String get inactivityModeLabel => 'Monitor bezruchu';

  @override
  String get inactivityModeDescription => 'Alarm, gdy nie wykryto ruchu.';

  @override
  String get alertFallDetected => 'WYKRYTO UDERZENIE!';

  @override
  String get alertFallBody => 'Wykryto poważny upadek. Wszystko w porządku?';

  @override
  String get alertInactivityDetected => 'WYKRYTO BEZRUCH!';

  @override
  String get alertInactivityBody => 'Brak ruchu. Wszystko w porządku?';

  @override
  String get btnImOkay => 'WSZYSTKO OK';

  @override
  String get disclaimerTitle => '⚠️ INFORMACJA PRAWNA I PRYWATNOŚĆ';

  @override
  String get disclaimerText =>
      'Oksigenia SOS to narzędzie wsparcia, nie zastępuje profesjonalnych służb ratunkowych. Działanie zależy od czynników zewnętrznych: baterii, sygnału GPS i zasięgu sieci komórkowej.\n\nAktywując tę aplikację akceptujesz, że oprogramowanie jest dostarczane „w obecnej formie” i zwalniasz programistów z odpowiedzialności prawnej za awarie techniczne. Sam odpowiadasz za swoje bezpieczeństwo.\n\nKoszty SMS: wszystkie koszty wiadomości ponosi użytkownik zgodnie z taryfą operatora. Oksigenia nie pokrywa ani nie pobiera opłat za te wiadomości.';

  @override
  String get btnAccept => 'AKCEPTUJĘ RYZYKO';

  @override
  String get btnDecline => 'WYJDŹ';

  @override
  String get privacyTitle => 'Warunki i prywatność';

  @override
  String get privacyPolicyContent =>
      'POLITYKA PRYWATNOŚCI I WARUNKI\n\n1. BRAK ZBIERANIA DANYCH\nOksigenia SOS działa lokalnie. Nie wysyłamy danych do chmury ani nie sprzedajemy twoich informacji.\n\n2. UPRAWNIENIA\n- Lokalizacja: do współrzędnych w przypadku alarmu.\n- SMS: wyłącznie do wysłania wiadomości alarmowej.\n\n3. OGRANICZENIE ODPOWIEDZIALNOŚCI\nAplikacja dostarczana „w obecnej formie”. Nie odpowiadamy za awarie zasięgu lub sprzętu.';

  @override
  String get advSettingsTitle => 'Funkcje zaawansowane';

  @override
  String get advSettingsSubtitle => 'Wiele kontaktów, śledzenie GPS...';

  @override
  String get dialogCommunityTitle => '💎 Społeczność Oksigenia';

  @override
  String get dialogCommunityBody => 'To wersja COMMUNITY (darmowa).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Subskrybuj PRO, aby odblokować wiele kontaktów i śledzenie w czasie rzeczywistym.';

  @override
  String get btnDonate => 'Postaw mi kawę ☕';

  @override
  String get btnSubscribe => 'Subskrybuj';

  @override
  String get btnClose => 'Zamknij';

  @override
  String get permSmsTitle => 'UWAGA! Uprawnienie SMS zablokowane';

  @override
  String get permSmsBody =>
      'Aplikacja NIE MOŻE wysyłać alertów nawet z zapisanymi kontaktami.';

  @override
  String get permSmsButton => 'Włącz SMS w ustawieniach';

  @override
  String get restrictedSettingsTitle => 'Ograniczone ustawienia';

  @override
  String get restrictedSettingsBody =>
      'Android ograniczył to uprawnienie, ponieważ aplikacja została zainstalowana ręcznie (sideload).';

  @override
  String get contactsTitle => 'Kontakty alarmowe';

  @override
  String get contactsSubtitle => 'Pierwszy (główny) otrzyma śledzenie GPS.';

  @override
  String get contactsAddHint => 'Dodaj numer';

  @override
  String get contactsEmpty => '⚠️ Brak kontaktów. Alert nie zostanie wysłany.';

  @override
  String get messageTitle => 'Wiadomość niestandardowa';

  @override
  String get messageSubtitle => 'Wysyłana PRZED współrzędnymi.';

  @override
  String get messageHint => 'Np: Cukrzyk. Trasa północna...';

  @override
  String get trackingTitle => 'Śledzenie GPS';

  @override
  String get trackingSubtitle => 'Wysyła pozycję do głównego kontaktu co X.';

  @override
  String get trackOff => '❌ Wyłączone';

  @override
  String get track30 => '⏱️ Co 30 min';

  @override
  String get track60 => '⏱️ Co 1 godzinę';

  @override
  String get track120 => '⏱️ Co 2 godziny';

  @override
  String get inactivityTimeTitle => 'Czas przed alertem';

  @override
  String get inactivityTimeSubtitle => 'Jak długo bez ruchu przed alarmem?';

  @override
  String get ina30s => '🧪 30 s (Tryb TEST)';

  @override
  String get ina1h => '⏱️ 1 godzina (Zalecane)';

  @override
  String get ina2h => '⏱️ 2 godziny (Długa przerwa)';

  @override
  String get testModeWarning => 'TRYB TEST AKTYWNY: alarm zadziała za 30 s.';

  @override
  String get toastHoldToSOS => 'Przytrzymaj przycisk SOS';

  @override
  String get donateDialogTitle => '💎 Wesprzyj projekt';

  @override
  String get donateDialogBody =>
      'Aplikacja jest darmowa i open source. Jeśli chroni cię w terenie, postaw nam kawę.';

  @override
  String get donateBtn => 'Wpłać przez PayPal';

  @override
  String get donateClose => 'ZAMKNIJ';

  @override
  String get alertSendingIn => 'Wysyłam alert za...';

  @override
  String get alertCancel => 'ANULUJ';

  @override
  String get warningKeepAlive =>
      '⚠️ WAŻNE: Nie zamykaj aplikacji przesuwając (Menedżer zadań). Zostaw w tle, aby mogła się sama uruchomić.';

  @override
  String get aboutTitle => 'O aplikacji';

  @override
  String get aboutVersion => 'Wersja';

  @override
  String get aboutDisclaimer => 'Informacja prawna';

  @override
  String get aboutPrivacy => 'Polityka prywatności';

  @override
  String get aboutSourceCode => 'Kod źródłowy (GitHub)';

  @override
  String get aboutLicenses => 'Licencje oprogramowania';

  @override
  String get aboutDevelopedBy => 'Stworzono z ❤️ przez Oksigenia';

  @override
  String get dialogClose => 'Zamknij';

  @override
  String get permSmsText =>
      'Brak uprawnień SMS. Aplikacja nie może wysyłać alertów.';

  @override
  String get phoneLabel => 'Telefon (np. +48...)';

  @override
  String get btnAdd => 'DODAJ';

  @override
  String get noContacts => 'Brak skonfigurowanych kontaktów.';

  @override
  String get inactivityTitle => 'Czas bezruchu';

  @override
  String get invalidNumberWarning => 'Numer nieprawidłowy lub za krótki';

  @override
  String get contactMain => 'Główny (Śledzenie / Bateria)';

  @override
  String get inactivitySubtitle => 'Czas bez ruchu przed wezwaniem pomocy.';

  @override
  String get dialogPermissionTitle => 'Jak włączyć uprawnienia';

  @override
  String get dialogPermissionStep1 =>
      '1. Naciśnij „PRZEJDŹ DO USTAWIEŃ” poniżej.';

  @override
  String get dialogPermissionStep2 =>
      '2. Na nowym ekranie naciśnij 3 kropki (⠇) w prawym górnym rogu.';

  @override
  String get dialogPermissionStep3 =>
      '3. Wybierz „Zezwól na ograniczone ustawienia” (jeśli widoczne).';

  @override
  String get dialogPermissionStep4 => '4. Wróć do tej aplikacji.';

  @override
  String get btnGoToSettings => 'PRZEJDŹ DO USTAWIEŃ';

  @override
  String get timerLabel => 'Timer';

  @override
  String get timerSeconds => 's';

  @override
  String get permSmsOk => 'Uprawnienie SMS aktywne';

  @override
  String get permSensorsOk => 'Czujniki aktywne';

  @override
  String get permNotifOk => 'Powiadomienia aktywne';

  @override
  String get permSmsMissing => 'Brak uprawnienia SMS';

  @override
  String get permSensorsMissing => 'Brak czujników';

  @override
  String get permNotifMissing => 'Brak powiadomień';

  @override
  String get permOverlayMissing => 'Brak nakładki';

  @override
  String get permDialogTitle => 'Wymagane uprawnienie';

  @override
  String get permSmsHelpTitle => 'Pomoc SMS';

  @override
  String get permGoSettings => 'Przejdź do ustawień';

  @override
  String get gpsHelpTitle => 'O GPS';

  @override
  String get gpsHelpBody =>
      'Dokładność zależy od fizycznego chipu telefonu i bezpośredniej widoczności nieba.\n\nW pomieszczeniach, garażach lub tunelach sygnał satelity jest blokowany, a lokalizacja może być przybliżona lub niedostępna.\n\nOksigenia zawsze postara się triangulować najlepszą możliwą pozycję.';

  @override
  String get holdToCancel => 'Przytrzymaj, aby anulować';

  @override
  String get statusMonitorStopped => 'Monitor zatrzymany.';

  @override
  String get statusScreenSleep => 'Ekran wkrótce zgaśnie.';

  @override
  String get btnRestartSystem => 'ZRESTARTUJ SYSTEM';

  @override
  String get smsDyingGasp => 'BATERIA <5%. System się wyłącza. Lok:';

  @override
  String get smsHelpMessage => 'POMOCY! Potrzebuję wsparcia.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - aktualizacja (to NIE nowy alarm):';

  @override
  String get batteryDialogTitle => 'Ograniczenie baterii';

  @override
  String get btnDisableBatterySaver => 'WYŁĄCZ OSZCZĘDZANIE';

  @override
  String get batteryDialogBody =>
      'System ogranicza baterię tej aplikacji. Aby SOS działało w tle, wybierz „Bez ograniczeń” lub „Nie optymalizuj”.';

  @override
  String get permBgLocationTitle => 'GPS w tle';

  @override
  String get bgLocationDialogBody =>
      'Gdy alarm się uruchamia, telefon zwykle leży w kieszeni z wygaszonym ekranem. Aby SOS wyszedł z Twoją dokładną pozycją w tym momencie, Android wymaga poziomu lokalizacji „Zawsze zezwalaj”.\n\nTwoja lokalizacja nigdy nie opuszcza telefonu: bez internetu, bez chmury, bez trackerów — podróżuje wyłącznie w SMS-ie SOS do Twoich własnych kontaktów.\n\nNa następnym ekranie wybierz „Zawsze zezwalaj”.';

  @override
  String get whyPermsBgLocation =>
      'Pobiera Twoją pozycję GPS przy wygaszonym ekranie lub aplikacji w tle — dokładnie wtedy, gdy uruchamia się SOS. Lokalizacja jest wysyłana wyłącznie w SMS-ie SOS do Twoich kontaktów; w żaden inny sposób nie opuszcza telefonu.';

  @override
  String get btnEnableBgLocation => 'Zawsze zezwalaj';

  @override
  String get permLocMissing => 'Brak uprawnienia lokalizacji';

  @override
  String get slideStopSystem => 'PRZESUŃ, ABY ZATRZYMAĆ';

  @override
  String get onboardingTitle => 'Skonfiguruj system bezpieczeństwa';

  @override
  String get onboardingSubtitle =>
      'Te uprawnienia są niezbędne, aby Oksigenia SOS chroniła cię w terenie.';

  @override
  String get onboardingGrant => 'ZEZWÓL';

  @override
  String get onboardingGranted => 'ZEZWOLONE ✓';

  @override
  String get onboardingNext => 'DALEJ';

  @override
  String get onboardingFinish => 'GOTOWE — URUCHOM MONITORING';

  @override
  String get onboardingMandatory => 'Wymagane do aktywacji monitoringu';

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get fullScreenIntentTitle => 'Alarm na ekranie blokady';

  @override
  String get fullScreenIntentBody =>
      'Pozwala alarmowi pojawić się na ekranie blokady. Bez tego alarm dźwięczy, ale ekran się nie budzi. Na Android 14+: Ustawienia → Aplikacje → Oksigenia SOS → Powiadomienia pełnoekranowe.';

  @override
  String get btnEnableFullScreenIntent => 'WŁĄCZ';

  @override
  String get pauseMonitoringSheet => 'Wstrzymaj monitoring na...';

  @override
  String get pauseTitle => 'Monitoring wstrzymany';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Wstrzymano · pozostało $time';
  }

  @override
  String get pauseResumeNow => 'Wznów teraz';

  @override
  String get pauseResumedMsg => 'Monitoring wznowiony';

  @override
  String get pauseHoldHint => 'Przytrzymaj, aby wstrzymać';

  @override
  String get pauseSec5 => '5 sekund';

  @override
  String get liveTrackingTitle => 'Live Tracking';

  @override
  String get liveTrackingSubtitle =>
      'Wysyła pozycję GPS przez SMS w regularnych odstępach.';

  @override
  String get liveTrackingInterval => 'Interwał wysyłki';

  @override
  String get liveTrackingShutdownReminder => 'Przypomnienie o wyłączeniu';

  @override
  String get liveTrackingNoReminder => '❌ Bez przypomnienia';

  @override
  String get liveTrackingReminder2h => '⏰ Po 2 godzinach';

  @override
  String get liveTrackingReminder3h => '⏰ Po 3 godzinach';

  @override
  String get liveTrackingReminder4h => '⏰ Po 4 godzinach';

  @override
  String get liveTrackingReminder5h => '⏰ Po 5 godzinach';

  @override
  String get liveTrackingLegalTitle => '⚠️ Koszty SMS';

  @override
  String get liveTrackingLegalBody =>
      'Live Tracking wysyła jeden SMS na interwał do głównego kontaktu. Obowiązują taryfy operatora. Wszystkie koszty SMS ponosisz wyłącznie ty.';

  @override
  String get liveTrackingActivate => 'AKTYWUJ TRACKING';

  @override
  String get liveTrackingDeactivate => 'DEAKTYWUJ';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Następna aktualizacja za $time';
  }

  @override
  String get liveTrackingCardTitle => 'Live Tracking aktywny';

  @override
  String get liveTrackingPausedSOS => 'Wstrzymano — SOS aktywne';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'TRYB TEST: Live Tracking wyśle co $time.';
  }

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get whyPermsTitle => 'Po co te uprawnienia?';

  @override
  String get whyPermsSms =>
      'Wysyła alerty awaryjne SMS-em do twoich kontaktów. Działa bez internetu.';

  @override
  String get whyPermsLocation =>
      'Dołącza współrzędne GPS do alertu, aby ratownicy wiedzieli, gdzie jesteś.';

  @override
  String get whyPermsNotifications =>
      'Pokazuje status monitoringu i pozwala anulować fałszywy alarm z ekranu blokady.';

  @override
  String get whyPermsActivity =>
      'Wykrywa wzorce ruchu, aby uniknąć fałszywych alarmów podczas chodzenia lub biegu.';

  @override
  String get whyPermsSensors =>
      'Odczytuje akcelerometr, aby wykryć siłę G upadku.';

  @override
  String get whyPermsBattery =>
      'Zapobiega wyłączaniu aplikacji przez Androida podczas monitorowania w tle.';

  @override
  String get whyPermsFullScreen =>
      'Pokazuje alarm na ekranie blokady, abyś mógł zareagować bez odblokowywania.';

  @override
  String get sentinelGreen => 'System aktywny';

  @override
  String get sentinelYellow => 'Wykryto uderzenie · analiza...';

  @override
  String get sentinelOrange => 'Alarm nadchodzi!';

  @override
  String get sentinelRed => 'ALARM AKTYWNY';

  @override
  String get activityProfileTitle => 'Profil aktywności';

  @override
  String get activityProfileSubtitle =>
      'Dostosowuje wykrywanie Smart Sentinel do twojego sportu. Wybierz najbliższe dopasowanie — niewłaściwe profile powodują fałszywe alarmy lub przegapiają prawdziwe upadki.';

  @override
  String get profileTrekking => 'Trekking / Wędrówki';

  @override
  String get profileTrekkingDesc =>
      'Domyślny. Chodzenie na zewnątrz z telefonem w kieszeni lub plecaku. Zrównoważona czułość.';

  @override
  String get profileRunning => 'Bieganie (asfalt)';

  @override
  String get profileRunningDesc =>
      'Bieganie po asfalcie lub twardej nawierzchni. Wyższy próg uderzenia (10G) i adaptacyjny detektor kadencji — radzi sobie z utrzymującym się poziomym reżimem G biegu, który łamie standardowy detektor kadencji.';

  @override
  String get profileTrailMtb => 'Trail running / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Wyższy próg uderzenia i bardziej tolerancyjna kadencja — stałe wibracje na nierównym terenie powodowałyby fałszywe alarmy.';

  @override
  String get profileMountaineering => 'Alpinizm';

  @override
  String get profileMountaineeringDesc =>
      'Tak samo jak trekking, ale z dłuższym 90-sekundowym oknem obserwacji po uderzeniu, dla powolnego dochodzenia do siebie w trudnym terenie.';

  @override
  String get profileParagliding => 'Paralotniarstwo';

  @override
  String get profileParaglidingDesc =>
      'Automatyczne wykrywanie upadku jest WYŁĄCZONE — akcelerometr nie potrafi niezawodnie odróżnić manewrów lotu od upadku. Ręczne SOS i monitor bezruchu pozostają aktywne.';

  @override
  String get profileKayak => 'Kajak / Sporty wodne';

  @override
  String get profileKayakDesc =>
      'Automatyczne wykrywanie upadku jest WYŁĄCZONE — woda pochłania uderzenia, a ruch unoszenia się nie jest informatywny. Korzystaj z monitora bezruchu i ręcznego SOS.';

  @override
  String get profileEquitation => 'Jeździectwo';

  @override
  String get profileEquitationDesc =>
      'Automatyczne wykrywanie upadku jest WYŁĄCZONE — kadencja konia (kłus, galop) zakłóca detektor ludzkiego chodu. Monitor bezruchu i ręczne SOS chronią podczas jazdy.';

  @override
  String get profileProfessional => 'Profesjonalny / Ratownictwo';

  @override
  String get profileProfessionalDesc =>
      'Wydłużone 120-sekundowe okno obserwacji do zaawansowanego użytku operacyjnego, gdy czas dochodzenia do siebie po upadku może przekraczać standardowe limity.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Uderzenie ${imp}G · Obs ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Uderzenie WYŁ · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'NIEUZBROJONY — dotknij przełącznika poniżej, aby aktywować';

  @override
  String get homeAlertSensorPermDenied => 'Brak uprawnień do czujników';

  @override
  String get homeConfirmTitleImpact => 'Wykrywanie uderzeń';

  @override
  String get homeConfirmTitleObservation => 'Obserwacja';

  @override
  String get homeConfirmTitleGps => 'Interwał GPS';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'WŁ · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'WYŁ';

  @override
  String get homeProfileNoFallWarning =>
      'Ten profil NIE wykrywa upadków. SOS musi być uruchomiony ręcznie.';

  @override
  String get homeActionApply => 'Zastosuj';

  @override
  String get smsBeaconDistance => 'od punktu SOS.';

  @override
  String get homeBeaconBanner =>
      'Wysyłanie lokalizacji do kontaktu po SOS — dotknij, aby zatrzymać';

  @override
  String get beaconStopped => 'Powiadomienia o ruchu zatrzymane';
}

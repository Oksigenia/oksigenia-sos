// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Система Oksigenia готова.';

  @override
  String get statusConnecting => 'Подключение к спутникам...';

  @override
  String get statusLocationFixed => 'ПОЗИЦИЯ ЗАФИКСИРОВАНА';

  @override
  String get statusSent => 'Тревога отправлена успешно.';

  @override
  String get alarmSendingNow => 'Отправка сигнала…';

  @override
  String get alarmSendFailed => 'SOS НЕ ОТПРАВЛЕН';

  @override
  String get btnRetry => 'Повторить';

  @override
  String get statusSendFailed => '⚠️ SOS НЕ ОТПРАВЛЕН';

  @override
  String get statusSendFailedBody =>
      'Не удалось отправить ни одного SMS. Проверьте сигнал сети и контакты, затем повторите.';

  @override
  String statusError(Object error) {
    return 'ОШИБКА: $error';
  }

  @override
  String get menuWeb => 'Официальный сайт';

  @override
  String get menuSupport => 'Техподдержка';

  @override
  String get menuLanguages => 'Язык';

  @override
  String get menuSettings => 'Настройки';

  @override
  String get menuPrivacy => 'Конфиденциальность';

  @override
  String get menuDonate => 'Поддержать / Donate';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ТРЕВОГА OKSIGENIA* 🆘\n\nМне нужна срочная помощь.\n📍 Местоположение: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Настройки SOS';

  @override
  String get settingsLabel => 'Аварийный телефон';

  @override
  String get settingsHint => 'Напр.: +7 900 123 4567';

  @override
  String get settingsSave => 'СОХРАНИТЬ';

  @override
  String get settingsSavedMsg => 'Контакт сохранён';

  @override
  String get errorNoContact => '⚠️ Сначала добавь контакт!';

  @override
  String get autoModeLabel => 'Детектор падений';

  @override
  String get autoModeDescription => 'Отслеживает сильные удары.';

  @override
  String get inactivityModeLabel => 'Монитор бездействия';

  @override
  String get inactivityModeDescription => 'Тревога при отсутствии движения.';

  @override
  String get alertFallDetected => 'ОБНАРУЖЕН УДАР!';

  @override
  String get alertFallBody => 'Обнаружено серьёзное падение. Всё в порядке?';

  @override
  String get alertInactivityDetected => 'ОБНАРУЖЕНО БЕЗДЕЙСТВИЕ!';

  @override
  String get alertInactivityBody => 'Движение не обнаружено. Всё в порядке?';

  @override
  String get btnImOkay => 'Я В ПОРЯДКЕ';

  @override
  String get disclaimerTitle => '⚠️ ЮРИДИЧЕСКОЕ УВЕДОМЛЕНИЕ';

  @override
  String get disclaimerText =>
      'Oksigenia SOS — это вспомогательный инструмент, а не замена профессиональным аварийным службам. Работа зависит от внешних факторов: батареи, GPS-сигнала и покрытия мобильной сети.\n\nАктивируя приложение, вы принимаете, что ПО предоставляется «как есть», и освобождаете разработчиков от юридической ответственности за технические сбои. Вы сами отвечаете за свою безопасность.\n\nСтоимость SMS: все расходы на сообщения несёт пользователь по тарифам своего оператора. Oksigenia не покрывает и не взимает плату за эти сообщения.';

  @override
  String get btnAccept => 'ПРИНИМАЮ РИСК';

  @override
  String get btnDecline => 'ВЫЙТИ';

  @override
  String get privacyTitle => 'Условия и конфиденциальность';

  @override
  String get privacyPolicyContent =>
      'ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ\n\n1. БЕЗ СБОРА ДАННЫХ\nOksigenia SOS работает локально. Мы не загружаем данные в облако и не продаём вашу информацию.\n\n2. РАЗРЕШЕНИЯ\n- Местоположение: для координат при тревоге.\n- SMS: исключительно для отправки сообщения о бедствии.\n\n3. ОГРАНИЧЕНИЕ ОТВЕТСТВЕННОСТИ\nПриложение предоставляется «как есть». Не несём ответственности за сбои покрытия или оборудования.';

  @override
  String get advSettingsTitle => 'Расширенные функции';

  @override
  String get advSettingsSubtitle => 'Несколько контактов, GPS-трекинг...';

  @override
  String get dialogCommunityTitle => '💎 Сообщество Oksigenia';

  @override
  String get dialogCommunityBody => 'Это версия COMMUNITY (бесплатная).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Подпишись на PRO, чтобы открыть несколько контактов и трекинг в реальном времени.';

  @override
  String get btnDonate => 'Купи мне кофе ☕';

  @override
  String get btnSubscribe => 'Подписаться';

  @override
  String get btnClose => 'Закрыть';

  @override
  String get permSmsTitle => 'ОПАСНО! Разрешение на SMS заблокировано';

  @override
  String get permSmsBody =>
      'Приложение НЕ СМОЖЕТ отправлять тревоги даже с сохранёнными контактами.';

  @override
  String get permSmsButton => 'Включить SMS в настройках';

  @override
  String get restrictedSettingsTitle => 'Ограниченные настройки';

  @override
  String get restrictedSettingsBody =>
      'Android ограничил это разрешение, потому что приложение установлено вручную (sideload).';

  @override
  String get contactsTitle => 'Аварийные контакты';

  @override
  String get contactsSubtitle => 'Первый (главный) получит GPS-трекинг.';

  @override
  String get contactsAddHint => 'Добавить номер';

  @override
  String get contactsEmpty => '⚠️ Нет контактов. Тревога не уйдёт.';

  @override
  String get messageTitle => 'Своё сообщение';

  @override
  String get messageSubtitle => 'Отправляется ПЕРЕД координатами.';

  @override
  String get messageHint => 'Напр.: Диабет. Северный маршрут...';

  @override
  String get trackingTitle => 'GPS-трекинг';

  @override
  String get trackingSubtitle =>
      'Отправляет позицию главному контакту каждые X.';

  @override
  String get trackOff => '❌ Выключено';

  @override
  String get track30 => '⏱️ Каждые 30 мин';

  @override
  String get track60 => '⏱️ Каждый час';

  @override
  String get track120 => '⏱️ Каждые 2 часа';

  @override
  String get inactivityTimeTitle => 'Время до тревоги';

  @override
  String get inactivityTimeSubtitle =>
      'Сколько времени без движения до тревоги?';

  @override
  String get ina30s => '🧪 30 с (Тестовый режим)';

  @override
  String get ina1h => '⏱️ 1 час (Рекомендуется)';

  @override
  String get ina2h => '⏱️ 2 часа (Долгий перерыв)';

  @override
  String get testModeWarning => 'ТЕСТ-РЕЖИМ: тревога сработает через 30 с.';

  @override
  String get toastHoldToSOS => 'Удерживай кнопку SOS';

  @override
  String get donateDialogTitle => '💎 Поддержи проект';

  @override
  String get donateDialogBody =>
      'Это бесплатное и open-source ПО. Если оно держит тебя в безопасности, угости нас кофе.';

  @override
  String get donateBtn => 'Поддержать через PayPal';

  @override
  String get donateClose => 'ЗАКРЫТЬ';

  @override
  String get alertSendingIn => 'Тревога через...';

  @override
  String get alertCancel => 'ОТМЕНА';

  @override
  String get warningKeepAlive =>
      '⚠️ ВАЖНО: не закрывай приложение свайпом (диспетчер задач). Оставь в фоне, чтобы оно могло само перезапуститься.';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutDisclaimer => 'Юридическое уведомление';

  @override
  String get aboutPrivacy => 'Политика конфиденциальности';

  @override
  String get aboutSourceCode => 'Исходный код (GitHub)';

  @override
  String get aboutLicenses => 'Лицензии ПО';

  @override
  String get aboutDevelopedBy => 'Сделано с ❤️ Oksigenia';

  @override
  String get dialogClose => 'Закрыть';

  @override
  String get permSmsText =>
      'Нет разрешений SMS. Приложение не может отправлять тревоги.';

  @override
  String get phoneLabel => 'Телефон (напр. +7...)';

  @override
  String get btnAdd => 'ДОБАВИТЬ';

  @override
  String get noContacts => 'Контакты не настроены.';

  @override
  String get inactivityTitle => 'Время бездействия';

  @override
  String get invalidNumberWarning => 'Номер неверный или слишком короткий';

  @override
  String get contactMain => 'Главный (Трекинг / Батарея)';

  @override
  String get inactivitySubtitle => 'Время без движения до вызова помощи.';

  @override
  String get dialogPermissionTitle => 'Как включить разрешения';

  @override
  String get dialogPermissionStep1 => '1. Нажми «ПЕРЕЙТИ В НАСТРОЙКИ» ниже.';

  @override
  String get dialogPermissionStep2 =>
      '2. На новом экране нажми 3 точки (⠇) сверху справа.';

  @override
  String get dialogPermissionStep3 =>
      '3. Выбери «Разрешить ограниченные настройки» (если видно).';

  @override
  String get dialogPermissionStep4 => '4. Вернись в это приложение.';

  @override
  String get btnGoToSettings => 'ПЕРЕЙТИ В НАСТРОЙКИ';

  @override
  String get timerLabel => 'Таймер';

  @override
  String get timerSeconds => 'с';

  @override
  String get permSmsOk => 'Разрешение SMS активно';

  @override
  String get permSensorsOk => 'Датчики активны';

  @override
  String get permNotifOk => 'Уведомления активны';

  @override
  String get permSmsMissing => 'Нет разрешения SMS';

  @override
  String get permSensorsMissing => 'Нет датчиков';

  @override
  String get permNotifMissing => 'Нет уведомлений';

  @override
  String get permOverlayMissing => 'Нет наложения';

  @override
  String get permDialogTitle => 'Требуется разрешение';

  @override
  String get permSmsHelpTitle => 'Помощь по SMS';

  @override
  String get permGoSettings => 'В настройки';

  @override
  String get gpsHelpTitle => 'О GPS';

  @override
  String get gpsHelpBody =>
      'Точность зависит от физического чипа телефона и прямой видимости неба.\n\nВнутри помещений, в гаражах или туннелях сигнал спутника блокируется, и местоположение может быть приблизительным или отсутствовать.\n\nOksigenia всегда попытается определить наилучшую возможную позицию.';

  @override
  String get holdToCancel => 'Удерживай для отмены';

  @override
  String get statusMonitorStopped => 'Монитор остановлен.';

  @override
  String get statusScreenSleep => 'Экран скоро погаснет.';

  @override
  String get btnRestartSystem => 'ПЕРЕЗАПУСТИТЬ';

  @override
  String get smsDyingGasp => 'БАТАРЕЯ <5%. Система выключается. Лок:';

  @override
  String get smsHelpMessage => 'ПОМОГИТЕ! Нужна помощь.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - обновление (это НЕ новая тревога):';

  @override
  String get batteryDialogTitle => 'Ограничение батареи';

  @override
  String get btnDisableBatterySaver => 'ОТКЛЮЧИТЬ ЭКОНОМИЮ';

  @override
  String get batteryDialogBody =>
      'Система ограничивает батарею этого приложения. Чтобы SOS работал в фоне, выбери «Без ограничений» или «Не оптимизировать».';

  @override
  String get permBgLocationTitle => 'GPS в фоновом режиме';

  @override
  String get bgLocationDialogBody =>
      'Когда срабатывает тревога, телефон обычно лежит в кармане с выключенным экраном. Чтобы SOS ушёл с вашей точной позицией в этот момент, Android требует уровень геолокации «Разрешить всегда».\n\nВаша геопозиция никогда не покидает телефон: нет интернета, облака и трекеров — она передаётся только внутри SOS-SMS вашим собственным контактам.\n\nНа следующем экране выберите «Разрешить всегда».';

  @override
  String get whyPermsBgLocation =>
      'Получает вашу GPS-позицию при выключенном экране или приложении в фоне — именно тогда, когда срабатывает SOS. Геопозиция отправляется только в SOS-SMS вашим контактам; иначе она никогда не покидает телефон.';

  @override
  String get btnEnableBgLocation => 'Разрешить всегда';

  @override
  String get permLocMissing => 'Нет разрешения геолокации';

  @override
  String get slideStopSystem => 'ПЕРЕТАЩИ, ЧТОБЫ ОСТАНОВИТЬ';

  @override
  String get onboardingTitle => 'Настрой систему безопасности';

  @override
  String get onboardingSubtitle =>
      'Эти разрешения нужны, чтобы Oksigenia SOS защищала тебя в поле.';

  @override
  String get onboardingGrant => 'РАЗРЕШИТЬ';

  @override
  String get onboardingGranted => 'РАЗРЕШЕНО ✓';

  @override
  String get onboardingNext => 'ДАЛЕЕ';

  @override
  String get onboardingFinish => 'ГОТОВО — ЗАПУСТИТЬ МОНИТОРИНГ';

  @override
  String get onboardingMandatory => 'Требуется для активации мониторинга';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get fullScreenIntentTitle => 'Тревога на экране блокировки';

  @override
  String get fullScreenIntentBody =>
      'Позволяет тревоге появляться поверх экрана блокировки. Без этого тревога звучит, но экран не загорается. На Android 14+: Настройки → Приложения → Oksigenia SOS → Полноэкранные уведомления.';

  @override
  String get btnEnableFullScreenIntent => 'ВКЛЮЧИТЬ';

  @override
  String get pauseMonitoringSheet => 'Приостановить мониторинг на...';

  @override
  String get pauseTitle => 'Мониторинг приостановлен';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Пауза · осталось $time';
  }

  @override
  String get pauseResumeNow => 'Возобновить';

  @override
  String get pauseResumedMsg => 'Мониторинг возобновлён';

  @override
  String get pauseHoldHint => 'Удерживай для паузы';

  @override
  String get pauseSec5 => '5 секунд';

  @override
  String get liveTrackingTitle => 'Live Tracking';

  @override
  String get liveTrackingSubtitle =>
      'Отправляет GPS-позицию по SMS через регулярные интервалы.';

  @override
  String get liveTrackingInterval => 'Интервал отправки';

  @override
  String get liveTrackingShutdownReminder => 'Напоминание об отключении';

  @override
  String get liveTrackingNoReminder => '❌ Без напоминания';

  @override
  String get liveTrackingReminder2h => '⏰ Через 2 часа';

  @override
  String get liveTrackingReminder3h => '⏰ Через 3 часа';

  @override
  String get liveTrackingReminder4h => '⏰ Через 4 часа';

  @override
  String get liveTrackingReminder5h => '⏰ Через 5 часов';

  @override
  String get liveTrackingLegalTitle => '⚠️ Стоимость SMS';

  @override
  String get liveTrackingLegalBody =>
      'Live Tracking отправляет одну SMS за интервал главному контакту. Применяются тарифы оператора. Все расходы на SMS несёшь ты.';

  @override
  String get liveTrackingActivate => 'АКТИВИРОВАТЬ ТРЕКИНГ';

  @override
  String get liveTrackingDeactivate => 'ВЫКЛЮЧИТЬ';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Следующее обновление через $time';
  }

  @override
  String get liveTrackingCardTitle => 'Live Tracking активен';

  @override
  String get liveTrackingPausedSOS => 'Пауза — SOS активен';

  @override
  String get liveTrackingTest1m => '🧪 1 мин (ТЕСТ)';

  @override
  String get liveTrackingTest2m => '🧪 2 мин (ТЕСТ)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'ТЕСТ-РЕЖИМ: Live Tracking будет отправлять каждые $time.';
  }

  @override
  String get selectLanguage => 'Выбери язык';

  @override
  String get whyPermsTitle => 'Зачем эти разрешения?';

  @override
  String get whyPermsSms =>
      'Отправляет аварийные тревоги по SMS контактам. Работает без интернета.';

  @override
  String get whyPermsLocation =>
      'Включает GPS-координаты в тревогу, чтобы спасатели знали, где ты.';

  @override
  String get whyPermsNotifications =>
      'Показывает статус мониторинга и позволяет отменить ложную тревогу с экрана блокировки.';

  @override
  String get whyPermsActivity =>
      'Распознаёт паттерны движения, чтобы избежать ложных тревог при ходьбе или беге.';

  @override
  String get whyPermsSensors =>
      'Считывает акселерометр для определения G-силы падения.';

  @override
  String get whyPermsBattery =>
      'Не даёт Android выключать приложение во время фонового мониторинга.';

  @override
  String get whyPermsFullScreen =>
      'Показывает тревогу поверх экрана блокировки, чтобы ты мог реагировать без разблокировки.';

  @override
  String get sentinelGreen => 'Система активна';

  @override
  String get sentinelYellow => 'Удар обнаружен · анализ...';

  @override
  String get sentinelOrange => 'Тревога скоро!';

  @override
  String get sentinelRed => 'ТРЕВОГА АКТИВНА';

  @override
  String get activityProfileTitle => 'Профиль активности';

  @override
  String get activityProfileSubtitle =>
      'Настраивает Smart Sentinel под твой спорт. Выбери ближайший — неправильный профиль вызовет ложные тревоги или пропустит реальные падения.';

  @override
  String get profileTrekking => 'Треккинг / Походы';

  @override
  String get profileTrekkingDesc =>
      'По умолчанию. Ходьба на природе с телефоном в кармане или рюкзаке. Сбалансированная чувствительность.';

  @override
  String get profileRunning => 'Бег (асфальт)';

  @override
  String get profileRunningDesc =>
      'Бег по асфальту или твёрдому покрытию. Более высокий порог удара (10G) и адаптивный детектор каденции — справляется с устойчивым горизонтальным G-режимом бега, который ломает стандартный детектор каденции.';

  @override
  String get profileTrailMtb => 'Трейлраннинг / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Более высокий порог удара и более терпимая каденция — постоянная вибрация на неровной поверхности иначе вызвала бы ложные тревоги.';

  @override
  String get profileMountaineering => 'Альпинизм';

  @override
  String get profileMountaineeringDesc =>
      'Та же база, что и треккинг, но с более длинным окном наблюдения 90 секунд после удара, для медленного восстановления на технической местности.';

  @override
  String get profileParagliding => 'Парапланеризм';

  @override
  String get profileParaglidingDesc =>
      'Автоматический детектор падений ОТКЛЮЧЁН — акселерометр не может надёжно отличить манёвры полёта от падения. Ручной SOS и монитор бездействия остаются активны.';

  @override
  String get profileKayak => 'Каяк / Водные виды';

  @override
  String get profileKayakDesc =>
      'Автоматический детектор падений ОТКЛЮЧЁН — вода поглощает удары, а движение на плаву неинформативно. Используй монитор бездействия и ручной SOS.';

  @override
  String get profileEquitation => 'Конный спорт';

  @override
  String get profileEquitationDesc =>
      'Автоматический детектор падений ОТКЛЮЧЁН — каденция лошади (рысь, галоп) мешает детектору человеческой ходьбы. Монитор бездействия и ручной SOS защищают во время поездки.';

  @override
  String get profileProfessional => 'Профессиональный / Спасение';

  @override
  String get profileProfessionalDesc =>
      'Расширенное окно наблюдения 120 секунд для продвинутого оперативного использования, когда время восстановления после падения может превышать стандартные таймауты.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Удар ${imp}G · Набл $obsс · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Удар ВЫКЛ · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'НЕ АКТИВИРОВАНО — нажмите переключатель ниже для активации';

  @override
  String get homeAlertSensorPermDenied => 'Разрешение на датчики отклонено';

  @override
  String get homeConfirmTitleImpact => 'Обнаружение ударов';

  @override
  String get homeConfirmTitleObservation => 'Наблюдение';

  @override
  String get homeConfirmTitleGps => 'Интервал GPS';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'ВКЛ · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'ВЫКЛ';

  @override
  String get homeProfileNoFallWarning =>
      'Этот профиль НЕ обнаруживает падения. SOS должен быть активирован вручную.';

  @override
  String get homeActionApply => 'Применить';

  @override
  String get smsBeaconDistance => 'от точки SOS.';

  @override
  String get homeBeaconBanner =>
      'Отправка местоположения контакту после SOS — нажмите, чтобы остановить';

  @override
  String get beaconStopped => 'Оповещения о перемещении остановлены';
}

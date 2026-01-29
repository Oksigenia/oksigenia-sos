import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart';
import 'package:oksigenia_sos/services/preferences_service.dart';
import 'package:oksigenia_sos/services/background_service.dart'; 
import 'package:oksigenia_sos/screens/disclaimer_screen.dart';
import 'package:oksigenia_sos/screens/home_screen.dart';
import 'package:oksigenia_sos/logic/sos_logic.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔒 BLOQUEO DE ROTACIÓN
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // 1. INICIALIZACIÓN BÁSICA
  await PreferencesService().init(); 
  final prefs = await SharedPreferences.getInstance();

  // 2. DESPERTAR A SYLVIA
  await initializeService(); 
  
  final bool accepted = prefs.getBool('disclaimer_accepted') ?? false;
  final String? savedLang = prefs.getString('language_code');

  // 3. INICIALIZAR EL CEREBRO (Lógica SOS)
  final sosLogic = SOSLogic();
  
  // 🛑 CORRECCIÓN: Solo arrancamos la lógica (y pedimos permisos)
  // si el usuario YA ha aceptado el disclaimer anteriormente.
  // Si es nuevo, la lógica se iniciará cuando entre al HomeScreen.
  if (accepted) {
    await sosLogic.init();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sosLogic),
      ],
      child: OksigeniaApp(
        initialAccepted: accepted,
        savedLanguage: savedLang,
      ),
    ),
  );
}

class OksigeniaApp extends StatefulWidget {
  final bool initialAccepted;
  final String? savedLanguage;

  const OksigeniaApp({
    super.key, 
    required this.initialAccepted,
    this.savedLanguage
  });

  @override
  State<OksigeniaApp> createState() => _OksigeniaAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _OksigeniaAppState? state = context.findAncestorStateOfType<_OksigeniaAppState>();
    state?.setLocale(newLocale);
  }
}

class _OksigeniaAppState extends State<OksigeniaApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    if (widget.savedLanguage != null) {
      _locale = Locale(widget.savedLanguage!);
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, 
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      navigatorKey: oksigeniaNavigatorKey,

      debugShowCheckedModeBanner: false,
      title: 'Oksigenia SOS',
      
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C), 
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C), 
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, 

      locale: _locale,
      supportedLocales: const [
        Locale('en'), 
        Locale('es'), 
        Locale('fr'), 
        Locale('de'), 
        Locale('pt'), 
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      home: widget.initialAccepted 
          ? const HomeScreen() 
          : const DisclaimerScreen(),
    );
  }
}
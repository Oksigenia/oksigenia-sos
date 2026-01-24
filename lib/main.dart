import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart';
import 'package:oksigenia_sos/services/preferences_service.dart';
import 'package:oksigenia_sos/services/background_service.dart';
import 'package:oksigenia_sos/screens/disclaimer_screen.dart';
import 'package:oksigenia_sos/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await PreferencesService().init(); 
  final prefs = await SharedPreferences.getInstance();

  // Esto hará que la pantalla de inicio (splash) dure 1 segundo más, 
  // pero garantiza que Sylvia despierte tras un reinicio del móvil.
  await initializeService(); 
  
  final bool accepted = prefs.getBool('disclaimer_accepted') ?? false;
  final String? savedLang = prefs.getString('language_code');

  runApp(
    OksigeniaApp(
      initialAccepted: accepted,
      savedLanguage: savedLang,
    )
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
    // Forzamos el modo claro en la barra de sistema para evitar el negro en el arranque
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, 
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oksigenia SOS',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
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
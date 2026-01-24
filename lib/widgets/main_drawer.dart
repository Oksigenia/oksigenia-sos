import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart';
import 'package:oksigenia_sos/logic/sos_logic.dart';
import 'package:oksigenia_sos/main.dart'; 
import 'package:oksigenia_sos/screens/about_screen.dart';

class MainDrawer extends StatelessWidget {
  final SOSLogic sosLogic;

  const MainDrawer({super.key, required this.sosLogic});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFB71C1C)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.monitor_heart, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                const Text("Oksigenia SOS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(l10n.motto, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.menuLanguages),
            onTap: () {
              Navigator.pop(context);
              _showLanguageDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.menuSettings),
            onTap: () {
              Navigator.pop(context);
              sosLogic.openSettings(context);
            },
          ),
          
          // --- AQUÍ HEMOS QUITADO EL BOTÓN DE PRIVACIDAD REDUNDANTE ---

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),

          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
            title: Text(l10n.menuDonate),
            onTap: () {
              Navigator.pop(context);
              sosLogic.openDonation(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: Text(l10n.menuX),
            onTap: () => sosLogic.launchURL("https://x.com/oksigeniaX"), 
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(l10n.menuInsta),
            onTap: () => sosLogic.launchURL("https://instagram.com/oksigenia"),
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: Text(l10n.menuWeb),
            onTap: () => sosLogic.launchURL("https://oksigenia.com"),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => SimpleDialog(
      title: const Text('Idioma / Language'), 
      children: [
        _langOption(context, 'Español', const Locale('es')), 
        _langOption(context, 'English', const Locale('en')), 
        _langOption(context, 'Français', const Locale('fr')), 
        _langOption(context, 'Português', const Locale('pt')), 
        _langOption(context, 'Deutsch', const Locale('de'))
      ]
    ));
  }

  Widget _langOption(BuildContext context, String text, Locale locale) {
    return SimpleDialogOption(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('language_code', locale.languageCode);
        
        final service = FlutterBackgroundService();
        service.invoke('updateLanguage');

        if (context.mounted) {
          OksigeniaApp.setLocale(context, locale); 
          Navigator.pop(context); 
        }
      },
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(text, style: const TextStyle(fontSize: 18))),
    );
  }
}
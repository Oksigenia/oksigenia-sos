import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = "";
  String _buildNumber = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showLegalDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Text(content, style: const TextStyle(fontSize: 14)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.dialogClose),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutTitle),
        centerTitle: true,
        // Sin color fijo, se adapta al tema
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // LOGO Y VERSIÓN
          const SizedBox(height: 20),
          Center(
            // 🔄 CAMBIO AQUÍ: Usamos tu logo real en lugar del icono del sistema
            child: Image.asset(
              'assets/images/logo.png',
              width: 150, // Antes 120, ahora 150 para que se vea más grande
              height: 150,
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Oksigenia SOS",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "${l10n.aboutVersion} $_version (Build $_buildNumber)",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),

          // LISTA DE OPCIONES
          const Divider(),
          
          // 1. AVISO LEGAL
          ListTile(
            leading: const Icon(Icons.gavel),
            title: Text(l10n.aboutDisclaimer),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalDialog(
              context, 
              l10n.aboutDisclaimer, 
              l10n.disclaimerText 
            ),
          ),
          
          // 2. PRIVACIDAD
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(l10n.aboutPrivacy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalDialog(
              context, 
              l10n.aboutPrivacy, 
              l10n.privacyPolicyContent 
            ),
          ),

          const Divider(),

          // 3. LICENCIAS OPEN SOURCE
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(l10n.aboutLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: "Oksigenia SOS",
              applicationVersion: _version,
              // 🔄 CAMBIO AQUÍ TAMBIÉN: Logo real en la pantalla de licencias
              applicationIcon: Image.asset(
                'assets/images/logo.png', 
                width: 48, 
                height: 48
              ),
            ),
          ),

          // 4. CÓDIGO FUENTE
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(l10n.aboutSourceCode),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _launchURL("https://github.com/OksigeniaSL/oksigenia-sos"),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              l10n.aboutDevelopedBy,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // LOGO Y VERSIÓN
          const SizedBox(height: 20),
          const Center(
            child: Icon(Icons.monitor_heart, size: 80, color: Color(0xFFB71C1C)),
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
          
          // 1. AVISO LEGAL (Usa el texto que ya tienes en l10n)
          ListTile(
            leading: const Icon(Icons.gavel),
            title: Text(l10n.aboutDisclaimer),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalDialog(
              context, 
              l10n.aboutDisclaimer, 
              l10n.disclaimerText // Reutilizamos el texto largo del disclaimer
            ),
          ),
          
          // 2. PRIVACIDAD (Usa el texto que ya tienes en l10n)
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(l10n.aboutPrivacy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalDialog(
              context, 
              l10n.aboutPrivacy, 
              l10n.privacyPolicyContent // Reutilizamos el texto largo de privacidad
            ),
          ),

          const Divider(),

          // 3. LICENCIAS OPEN SOURCE (Nativo de Flutter)
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(l10n.aboutLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: "Oksigenia SOS",
              applicationVersion: _version,
              applicationIcon: const Icon(Icons.monitor_heart, color: Colors.red),
            ),
          ),

          // 4. CÓDIGO FUENTE (GitHub)
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

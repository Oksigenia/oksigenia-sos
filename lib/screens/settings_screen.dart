import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart'; 
import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {
  List<String> _contacts = [];
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int _selectedInterval = 0;
  int _selectedInactivity = 3600;
  bool _isSmsPermissionGranted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
    _checkPermissions();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detectCountryPrefix();
    });
  }

  void _detectCountryPrefix() {
    if (_phoneController.text.isNotEmpty) return;
    try {
      final Locale deviceLocale = PlatformDispatcher.instance.locale;
      final String countryCode = deviceLocale.countryCode ?? "ES";
      
      const Map<String, String> prefixes = {
        'ES': '+34', 'FR': '+33', 'PT': '+351', 'DE': '+49', 'IT': '+39',
        'UK': '+44', 'GB': '+44', 'US': '+1', 'CA': '+1', 'MX': '+52',
        'AR': '+54', 'CO': '+57', 'CL': '+56', 'PE': '+51'
      };

      if (prefixes.containsKey(countryCode)) {
        setState(() {
          _phoneController.text = prefixes[countryCode]!;
        });
      }
    } catch (_) {}
  }

  // 🛡️ VALIDADOR DE NÚMEROS
  bool _isValidPhoneNumber(String input) {
    String cleanInput = input.trim();
    if (cleanInput.isEmpty) return false;

    // 1. Regex: Solo permite números, +, espacios y guiones
    final RegExp validCharacters = RegExp(r'^[+0-9\-\s]+$');
    if (!validCharacters.hasMatch(cleanInput)) return false;

    // 2. Conteo de dígitos reales:
    String justDigits = cleanInput.replaceAll(RegExp(r'[^0-9]'), '');
    return justDigits.length >= 6;
  }

  // 💡 Diálogo de ayuda para permisos restringidos (Android 13+)
  void _showPermissionGuide(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dialogPermissionTitle), 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dialogPermissionStep1),
            const SizedBox(height: 8),
            Text(l10n.dialogPermissionStep2, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(l10n.dialogPermissionStep3),
            const SizedBox(height: 8),
            Text(l10n.dialogPermissionStep4),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.dialogClose ?? "Cerrar"), 
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings(); 
            },
            child: Text(l10n.btnGoToSettings),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    // Auto-guardado al salir (CON VALIDACIÓN)
    String pendingPhone = _phoneController.text.trim();
    if (_isValidPhoneNumber(pendingPhone) && !_contacts.contains(pendingPhone)) {
       PreferencesService().addContact(pendingPhone);
    }

    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.sms.status;
    setState(() {
      _isSmsPermissionGranted = status.isGranted;
    });
  }

  Future<void> _loadData() async {
    final prefs = PreferencesService();
    setState(() {
      _contacts = prefs.getContacts();
      _selectedInterval = prefs.getUpdateInterval();
      _selectedInactivity = prefs.getInactivityTime();
      _messageController.text = prefs.getSosMessage();
    });
  }

  void _addContact() {
    final l10n = AppLocalizations.of(context)!;

    // 1. Chequeo de Permisos
    if (!_isSmsPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ ${l10n.permSmsText}"), backgroundColor: Colors.red)
      );
      return;
    }

    String phone = _phoneController.text.trim();

    // 2. Chequeo de Validación
    if (!_isValidPhoneNumber(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠️ ${l10n.invalidNumberWarning}"), 
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        )
      );
      return;
    }

    // 3. Añadir si no está repetido
    if (!_contacts.contains(phone)) {
      setState(() {
        _contacts.add(phone);
        _phoneController.clear();
      });
      PreferencesService().addContact(phone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Contacto duplicado / Duplicate"))
      );
    }
  }

  void _removeContact(String phone) {
    setState(() {
      _contacts.remove(phone);
    });
    PreferencesService().removeContact(phone);
  }

  void _updateInterval(int? value) {
    if (value != null) {
      setState(() => _selectedInterval = value);
      PreferencesService().setUpdateInterval(value);
    }
  }

  void _updateInactivity(int? value) {
    if (value != null) {
      setState(() => _selectedInactivity = value);
      PreferencesService().setInactivityTime(value);
    }
  }

  void _saveMessage(String value) {
    PreferencesService().setSosMessage(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuSettings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECCION DE PERMISOS
            if (!_isSmsPermissionGranted)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  children: [
                    Row(children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l10n.permSmsText, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    ]),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _showPermissionGuide(context),
                      icon: const Icon(Icons.settings_applications),
                      label: Text(l10n.permSmsButton),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),

            Text(l10n.contactsTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.phoneLabel,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    // 🔥 MEJORA UX: Botón "Intro" del teclado añade el contacto
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addContact(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addContact,
                  child: const Icon(Icons.add), 
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // LISTA DE CONTACTOS CON JERARQUÍA VISUAL
            if (_contacts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(l10n.noContacts, style: const TextStyle(color: Colors.red)),
              )
            else
              ..._contacts.asMap().entries.map((entry) {
                int index = entry.key;
                String phone = entry.value;
                bool isPrimary = (index == 0);

                return Card(
                  elevation: isPrimary ? 2 : 0,
                  color: isPrimary ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3) : null,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: isPrimary 
                      ? const Icon(Icons.star, color: Colors.amber, size: 28) 
                      : const Icon(Icons.person),
                    title: Text(
                      phone,
                      style: TextStyle(
                        fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                        fontSize: isPrimary ? 18 : 16,
                      ),
                    ),
                    subtitle: isPrimary 
                      ? Text(l10n.contactMain, style: TextStyle(color: Colors.amber[800], fontSize: 12)) 
                      : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeContact(phone),
                    ),
                  ),
                );
              }),

            const Divider(height: 40),

            Text(l10n.messageTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(l10n.messageSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)), 
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: l10n.messageHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: _saveMessage,
              maxLines: 3,
            ),

            const Divider(height: 40),

            Text(l10n.inactivityTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(l10n.inactivitySubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedInactivity,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: 30, child: Text("TEST (30s)", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold))),
                    DropdownMenuItem(value: 3600, child: Text(l10n.ina1h)),
                    DropdownMenuItem(value: 7200, child: Text(l10n.ina2h)),
                  ],
                  onChanged: _updateInactivity,
                ),
              ),
            ),
            
            // 👇 TRACKING DESACTIVADO PARA v3.9.2
            /*
            const Divider(height: 40),

            Text(l10n.trackingTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(l10n.trackingSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedInterval,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(value: 0, child: Text(l10n.trackOff)),
                    DropdownMenuItem(value: 30, child: Text(l10n.track30)),
                    DropdownMenuItem(value: 60, child: Text(l10n.track60)),
                    DropdownMenuItem(value: 120, child: Text(l10n.track120)),
                  ],
                  onChanged: _updateInterval,
                ),
              ),
            ),
            */
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
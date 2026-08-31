// Trocea un mensaje en piezas que quepan CADA UNA en un solo SMS, para enviarlas
// con sendTextMessage (isMultipart:false) — la única vía que NO toca
// getGroupIdLevel1 / READ_PHONE_STATE en Android 17/GrapheneOS (issue #12).
//
// Reglas:
//  - Empaqueta líneas enteras (\n) mientras quepan; así conserva la estructura
//    del SOS (cabecera, enlace, extras) y el orden crítico-primero.
//  - Nunca parte un enlace ni una palabra a la fuerza: si una línea sola no cabe,
//    se trocea por espacios (los tokens —URLs incluidas— quedan intactos).
//  - Encoding-aware y CONSERVADOR: si una pieza lleva algún carácter no ASCII
//    (emoji, acento), se trata como UCS-2 (límite 67); si no, GSM 7-bit (152).
//    Los márgenes (<160/<70) garantizan que sendTextMessage NO auto-parta.
//  - Idioma-agnóstico: opera sobre caracteres, no sobre contenido.

const int _gsmLimit = 152; // margen bajo 160
const int _ucs2Limit = 67; // margen bajo 70

bool _isUcs2(String s) => s.runes.any((r) => r > 0x7F);

// Longitud en unidades que cuenta el SMS: UTF-16 code units (un emoji fuera del
// BMP cuenta 2, igual que en un SMS UCS-2). Para GSM el margen absorbe los
// caracteres de extensión (que ocupan 2 septetos).
bool _fits(String s) => s.length <= (_isUcs2(s) ? _ucs2Limit : _gsmLimit);

String _joinLine(String a, String b) => a.isEmpty ? b : '$a\n$b';
String _joinWord(String a, String b) => a.isEmpty ? b : '$a $b';

// Trocea una línea demasiado larga por espacios, sin romper tokens (URLs).
List<String> _splitLongLine(String line) {
  final out = <String>[];
  String cur = '';
  for (final word in line.split(' ')) {
    final candidate = _joinWord(cur, word);
    if (_fits(candidate)) {
      cur = candidate;
    } else {
      if (cur.isNotEmpty) out.add(cur);
      // Un token solo mayor que un SMS (extremadamente raro con coords cortas):
      // como último recurso se trocea por caracteres para no perder información.
      if (_fits(word)) {
        cur = word;
      } else {
        var rest = word;
        final max = _isUcs2(rest) ? _ucs2Limit : _gsmLimit;
        while (rest.length > max) {
          out.add(rest.substring(0, max));
          rest = rest.substring(max);
        }
        cur = rest;
      }
    }
  }
  if (cur.isNotEmpty) out.add(cur);
  return out;
}

/// Divide [message] en la lista mínima de piezas que quepan cada una en un solo
/// SMS. Nunca devuelve una pieza que fuerce al sistema a auto-partir.
List<String> splitSmsSafely(String message) {
  final pieces = <String>[];
  String cur = '';
  void flush() { if (cur.isNotEmpty) { pieces.add(cur); cur = ''; } }

  for (final line in message.split('\n')) {
    final candidate = _joinLine(cur, line);
    if (_fits(candidate)) {
      cur = candidate;
      continue;
    }
    flush();
    if (_fits(line)) {
      cur = line;
      continue;
    }
    // Línea que por sí sola no cabe → trocear por palabras.
    for (final sub in _splitLongLine(line)) {
      if (_fits(_joinLine(cur, sub))) {
        cur = _joinLine(cur, sub);
      } else {
        flush();
        cur = sub;
      }
    }
  }
  flush();
  return pieces.isEmpty ? [message] : pieces;
}

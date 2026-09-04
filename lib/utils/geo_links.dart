/// Bloque de ubicación para los SMS de Oksigenia. Máxima cobertura, tres vías:
///
/// 1. `geo:` — el esquema estándar de Android. Al tocarlo abre la app de mapas
///    *instalada* en el teléfono que recibe, sea cual sea: Google Maps en un
///    stock, OrganicMaps u OsmAnd en un dispositivo de-Googled (nuestro usuario
///    mayoritario). No es "la opción anti-Google": abre la nativa de cada uno.
/// 2. Google Maps por https — respaldo para lo que `geo:` no cubre: contactos en
///    iPhone y clientes de SMS que no enlazan el esquema `geo:`.
/// 3. OpenStreetMap por https — respaldo universal y libre; es una URL, así que
///    todo cliente la vuelve tocable y abre en el navegador en cualquier equipo.
///
/// Todo el bloque es GSM-7 (no fuerza UCS-2). Ver [splitSmsSafely].
String geoLinks(double lat, double lon) {
  final la = lat.toStringAsFixed(6);
  final lo = lon.toStringAsFixed(6);
  return 'geo:$la,$lo'
      '\nhttps://maps.google.com/?q=$la,$lo'
      '\nhttps://www.openstreetmap.org/?mlat=$la&mlon=$lo';
}

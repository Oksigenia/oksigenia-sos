# Oksigenia SOS 🆘

**Oksigenia SOS** is an open-source emergency response application designed for outdoor enthusiasts, solo travelers, and anyone needing a reliable safety net. It detects falls/impacts and automatically sends an SMS with your precise GPS coordinates to a predefined emergency contact.

![Oksigenia SOS Banner](assets/images/icon.png) ## 🚀 Key Features

* **🛡️ Automatic Fall Detection:** Uses device accelerometer to detect high-impact events (Logic v1.9).
* **📡 Native Background SMS:** Bypasses standard app limitations to send SMS even when the screen is off (Android).
* **🛰️ Parallel GPS Locking:** Starts searching for satellites immediately upon impact detection to ensure coordinates are ready before the countdown ends.
* **⚡ Zero-Server Architecture:** No accounts, no cloud tracking, no subscriptions. Your data stays on your phone.
* **🔋 Efficient:** Uses tactical vibration instead of audio alarms to save battery and work in noisy environments.
* **🌍 Multi-language:** EN, ES, FR, PT, DE.

## 🛠️ Installation

### Option 1: Direct APK (Recommended for Community)
Download the latest `app-community-release.apk` from our website or the Releases section.
* *Note:* Requires enabling "Install from unknown sources".

### Option 2: Build from Source
1.  Clone the repository.
2.  Ensure you have Flutter SDK installed (Java 17 required).
3.  Run: `flutter pub get`
4.  Build: `flutter build apk --release --flavor community`

## ⚠️ Disclaimer

**Oksigenia SOS is a support tool, NOT a replacement for professional emergency services (112, 911).**
Functionality depends on battery life, GPS signal, and cellular coverage. The developers are not liable for any failure in distress signal transmission. Use at your own risk.

---

# Oksigenia SOS (Español)

**Oksigenia SOS** es una aplicación de respuesta ante emergencias de código abierto. Detecta caídas e impactos fuertes y envía automáticamente un SMS con las coordenadas GPS precisas a tu contacto de emergencia.

## 🚀 Características Clave

* **Detección de Caídas:** Algoritmo ajustado para evitar falsos positivos en deportes.
* **SMS Nativo:** Envío directo a través de la red telefónica, sin depender de datos móviles (3G/4G).
* **GPS Paralelo:** Busca satélites durante la cuenta atrás para máxima precisión.
* **Privacidad Total:** Sin servidores, sin bases de datos.
* **Modo Omega:** Puente nativo (Kotlin) para garantizar la ejecución en segundo plano.

## 📄 Licencia
[Insertar Licencia aquí, p.ej. MIT o GPL]

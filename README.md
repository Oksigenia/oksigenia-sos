# Oksigenia SOS 🏔️

**Outdoor Emergency Assistant | FOSS | Privacy-First**

[ES] Oksigenia SOS es una herramienta de seguridad personal diseñada para deportes de montaña, trabajadores aislados y situaciones de riesgo. Funciona de manera autónoma, sin depender de servicios privativos.

[EN] Oksigenia SOS is a personal safety tool designed for mountain sports, lone workers, and risky situations. It operates autonomously without relying on proprietary services.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)]()
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR)

---

## 📸 Screenshots / Capturas

| Home | Settings | Alert |
|:---:|:---:|:---:|
| <img src="screenshots/screen_main.jpg" width="200" /> | <img src="screenshots/screen_settings.jpg" width="200" /> | <img src="screenshots/screen_alert.jpg" width="200" /> |
| **Sent / Enviado** | **FOSS Info** | **Legal** |
| <img src="screenshots/screen_send.jpg" width="200" /> | <img src="screenshots/screen_foss.jpg" width="200" /> | <img src="screenshots/Captura08.jpg" width="200" /> |

---

## 🚀 Features / Características (v3.5.0)

| Feature | English | Español |
|:---|:---|:---|
| 📉 **Fall Detection** | Detects severe impacts (>3.5G) and triggers the alarm automatically. | Detecta impactos severos (>3.5G) y activa la alarma automáticamente. |
| ⏱️ **Inactivity Monitor** | Triggers emergency protocol if no movement is detected for **60 minutes**. | Si no detecta movimiento durante **60 minutos**, inicia el protocolo de emergencia. |
| 🛰️ **Hardware GPS** | Uses hardware GPS chip directly. Works on GrapheneOS and De-Googled devices. | Usa el chip GPS por hardware. Funciona en GrapheneOS y dispositivos sin servicios de Google. |
| 🔋 **Battery Saver** | Releases screen lock after sending SOS to maximize survival time. | Tras el envío, libera el bloqueo de pantalla para maximizar la supervivencia de la batería. |
| 🔒 **Privacy** | No registration, no tracking, no cloud. Data only leaves via SMS. | Sin registros, sin rastreo, sin nube. Los datos solo salen vía SMS. |

---

## 🛠️ Download & Install / Descarga e Instalación

### 🌐 Official Website / Web Oficial
[EN] Download the APK directly from our official site:
[ES] Descarga el APK directamente desde nuestra web oficial:
👉 [**https://oksigenia.com/sos**](https://oksigenia.com/sos)

### 📦 GitHub Releases
[EN] Signed versions and SHA-256 security hashes:
[ES] Versiones firmadas y hashes de seguridad SHA-256:
[Releases Page](https://github.com/Oksigenia/oksigenia-sos/releases)

### 💻 Build from source / Compilar desde código
```bash
git clone [https://github.com/Oksigenia/oksigenia-sos.git](https://github.com/Oksigenia/oksigenia-sos.git)
flutter pub get
flutter build apk --release

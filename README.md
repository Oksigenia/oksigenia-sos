# Oksigenia SOS 🏔️ v3.8.0

**Outdoor Emergency Assistant | FOSS | Privacy-First**

![Oksigenia Feature Graphic](metadata/en-US/images/featureGraphic.jpg)

[ES] **Oksigenia SOS** es una herramienta de seguridad personal diseñada para deportes de montaña y situaciones de riesgo. Detecta caídas o inactividad y envía SMS automáticos con coordenadas GPS y telemetría vital. Funciona de manera autónoma, sin depender de servidores externos.

[EN] **Oksigenia SOS** is a personal safety tool designed for mountain sports and risky situations. It detects falls or inactivity and sends automatic SMS with GPS coordinates and vital telemetry. It operates autonomously without relying on proprietary servers.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)]()
[![Privacy](https://img.shields.io/badge/Privacy-Offline%20%20No%20Trackers-blue)]()

<br>

<p align="center">
  <a href="https://github.com/OksigeniaSL/oksigenia-sos/releases/latest">
    <img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroidButtonGreyBorder_nofont.png" height="70" alt="Get it on IzzyOnDroid">
  </a>
</p>

👉 **[Donate via PayPal / Donar con PayPal](https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR)** 💙

---

## 📸 Interface / Interfaz

| Dashboard | Menu & Config | Impact Alert |
|:---:|:---:|:---:|
| <img src="assets/images/screenshots/screen_main.jpg" width="185" alt="Home Screen Dashboard" /> | <img src="assets/images/screenshots/screen_settings.jpg" width="185" alt="Settings Menu" /> | <img src="assets/images/screenshots/screen_alert.jpg" width="185" alt="Red Alert Impact" /> |
| **Inactivity Alert** | **Test Mode & Status** | **Success / Enviado** |
| <img src="assets/images/screenshots/screen_alert_inactivity.jpg" width="185" alt="Red Alert Inactivity" /> | <img src="assets/images/screenshots/screen_testmode.jpg" width="185" alt="Test Mode Dashboard" /> | <img src="assets/images/screenshots/screen_send.jpg" width="185" alt="Success Blue Screen" /> |

---

## 🚀 New in v3.8.0 / Novedades

| Feature | English | Español |
|:---|:---|:---|
| 🚦 **Health Dashboard** | **Visual Status**. New main screen indicators for G-Force, Battery %, and GPS Accuracy. Know your system status at a glance. | **Semáforo de Salud**. Nuevos indicadores en pantalla principal: Fuerza G, Batería % y Precisión GPS. Estado del sistema de un vistazo. |
| 📡 **Smart Telemetry** | **Rich SMS**. Emergency messages now include Battery level, Altitude, and GPS Accuracy to help rescuers gauge the situation. | **SMS Enriquecido**. Los mensajes de socorro ahora incluyen nivel de Batería, Altitud y Precisión GPS para ayudar al rescate. |
| 🔊 **Audio Feedback** | **Confirmation Beep**. Distinctive sound plays when the SOS SMS is successfully sent, even if the phone is silenced. | **Confirmación Sonora**. Un sonido distintivo confirma el envío exitoso del SMS, incluso con el móvil en silencio. |
| 🛡️ **Android 14 Ready** | **Restricted Settings Tutorial**. Smart detection if Android blocks permissions, guiding users to unlock them manually. | **Tutorial Anti-Restricciones**. Detección inteligente si Android bloquea permisos, guiando al usuario para desbloquearlos. |
| 🔒 **Remote Kill-Switch** | **Safety First**. The app checks for critical updates on startup to ensure no obsolete versions are used in emergencies. | **Seguridad Remota**. La app verifica actualizaciones críticas al inicio para evitar el uso de versiones obsoletas en emergencias. |

---

## ⚠️ Critical Configuration / Configuración Crítica

### 🔋 1. Battery Optimization / Optimización de Batería
[EN] To ensure sensors and GPS never "sleep", you **must** disable battery optimization:
[ES] Para asegurar que los sensores y el GPS no se "duerman", **debes** desactivar la optimización:

1. Long press icon > **App Info (i)** / Mantén pulsado icono > **Información (i)**.
2. Go to **App battery usage** / Ve a **Uso de batería**.
3. Select **"Unrestricted"** / Selecciona **"Sin restricciones"**.

### 🛡️ 2. "Restricted Settings" (Android 13+)

[ES] Si ves un aviso de "Ajustes Restringidos" al activar los SMS:
1. Ve a **Ajustes > Apps > Oksigenia SOS**.
2. Pulsa los **tres puntos (⋮)** (arriba derecha) -> **"Permitir ajustes restringidos"**.

[EN] If you see a "Restricted Setting" warning when enabling SMS:
1. Go to **Settings > Apps > Oksigenia SOS**.
2. Tap **three dots (⋮)** (top right) -> **"Allow restricted settings"**.

<br clear="right"/>

---

## 🛠️ Download & Build

### 📦 Download APK
Check the **[Releases Section](https://github.com/OksigeniaSL/oksigenia-sos/releases)** for the latest signed APKs (Split APKs available for reduced size).

### 💻 Build from source
```bash
git clone [https://github.com/OksigeniaSL/oksigenia-sos.git](https://github.com/OksigeniaSL/oksigenia-sos.git)
cd oksigenia-sos
flutter pub get
# Create your key.properties first!
flutter build apk --release --split-per-abi

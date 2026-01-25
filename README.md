# Oksigenia SOS 🏔️ v3.9.0

**Outdoor Emergency Assistant | FOSS | Privacy-First**

![Oksigenia Feature Graphic](metadata/en-US/images/featureGraphic.jpg)

[ES] **Oksigenia SOS** es una herramienta de seguridad personal diseñada para deportes de montaña y situaciones de riesgo. Detecta caídas o inactividad y envía SMS automáticos con coordenadas GPS y telemetría vital. Funciona de manera autónoma, sin depender de servidores externos.

[EN] **Oksigenia SOS** is a personal safety tool designed for mountain sports and risky situations. It detects falls or inactivity and sends automatic SMS with GPS coordinates and vital telemetry. It operates autonomously without relying on proprietary servers.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)]()
[![Privacy](https://img.shields.io/badge/Privacy-Offline%20%20No%20Trackers-blue)]()

<br>

<p align="center">
  <a href="https://apt.izzysoft.de/packages/com.oksigenia.oksigenia_sos">
    <img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroidButtonGreyBorder_nofont.png" height="70" alt="Get it on IzzyOnDroid">
  </a>
</p>

👉 **[Donate via PayPal / Donar con PayPal](https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR)** 💙

---

## 📸 Interface / Interfaz

| Dashboard | Menu & Config | Impact Alert |
|:---:|:---:|:---:|
| <img src="screenshots/screen_main.jpg" width="185" alt="Home Screen Dashboard" /> | <img src="screenshots/screen_settings.jpg" width="185" alt="Settings Menu" /> | <img src="screenshots/screen_alert.jpg" width="185" alt="Red Alert Impact" /> |
| **Inactivity Alert** | **Test Mode & Status** | **Success / Enviado** |
| <img src="screenshots/screen_alert_inactivity.jpg" width="185" alt="Red Alert Inactivity" /> | <img src="screenshots/screen_testmode.jpg" width="185" alt="Test Mode Dashboard" /> | <img src="screenshots/screen_send.jpg" width="185" alt="Success Blue Screen" /> |

---

## 🚀 New in v3.9.0 / Novedades

| Feature | English | Español |
|:---|:---|:---|
| 🪫 **Dying Gasp** | **Last Breath Alert**. If battery drops below 5% while monitoring is active, an automatic SOS with location is sent before the phone dies. | **El Último Suspiro**. Si la batería baja del 5% con el monitor activo, envía un SOS automático con ubicación antes de apagarse. |
| 📉 **Smart Motion** | **High-Sensitivity Algorithm**. New physics engine distinguishes between active movement (stairs, jogging) and actual stillness, reducing false alarms. | **Algoritmo de Alta Sensibilidad**. Nuevo motor físico que distingue entre movimiento activo (escaleras, trote) e inmovilidad real, reduciendo falsas alarmas. |
| 🎨 **UI Redesign** | **High Visibility**. Larger dashboard icons (48dp) and precise G-Force decimals for better readability under stress. | **Alta Visibilidad**. Iconos del panel más grandes (48dp) y fuerza G con decimales precisos para mejor lectura bajo estrés. |
| 👻 **Status Icon** | **Clean Notification**. Fixed status bar icon rendering (silhouette) to comply with Android 14 standards. | **Icono de Estado**. Icono de barra de estado (silueta) corregido para cumplir con los estándares de Android 14. |
| 📡 **Rich Telemetry** | **Enhanced SOS**. (From v3.8) Messages now include Altitude, Battery %, and Accuracy to help rescuers gauge the context. | **Telemetría Avanzada**. (Desde v3.8) Los mensajes incluyen Altitud, Batería % y Precisión para dar contexto al rescate. |

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

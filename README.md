# Oksigenia SOS 🏔️ v3.7.1

**Outdoor Emergency Assistant | FOSS | Privacy-First**

![Oksigenia Feature Graphic](metadata/en-US/images/featureGraphic.jpg)

[ES] **Oksigenia SOS** es una herramienta de seguridad personal diseñada para deportes de montaña y situaciones de riesgo. Detecta caídas o inactividad y envía SMS automáticos con coordenadas GPS. Funciona de manera autónoma, sin depender de servicios privativos.

[EN] **Oksigenia SOS** is a personal safety tool designed for mountain sports and risky situations. It detects falls or inactivity and sends automatic SMS with GPS coordinates. It operates autonomously without relying on proprietary services.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)]()
[![Privacy](https://img.shields.io/badge/Privacy-Offline%20%20No%20Trackers-blue)]()
<a href="https://apt.izzysoft.de/packages/com.oksigenia.oksigenia_sos">
  <img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroidButtonGreyBorder_nofont.png" height="55" alt="Get it on IzzyOnDroid">
</a>

👉 **[Donate via PayPal / Donar con PayPal](https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR)** 💙

---

## 📸 Screenshots / Capturas

| Home | Menu | Alert |
|:---:|:---:|:---:|
| <img src="metadata/en-US/images/phoneScreenshots/screen_main.jpg" width="200" alt="Home Screen Monitoring" /> | <img src="metadata/en-US/images/phoneScreenshots/screen_settings.jpg" width="200" alt="Menu" /> | <img src="metadata/en-US/images/phoneScreenshots/screen_alert.jpg" width="200" alt="Red Alert" /> |
| **Success / Enviado** | **FOSS / Donate** | **Legal** |
| <img src="metadata/en-US/images/phoneScreenshots/screen_send.jpg" width="200" alt="Success Blue Screen" /> | <img src="metadata/en-US/images/phoneScreenshots/screen_foss.jpg" width="200" alt="Donation Dialog" /> | <img src="metadata/en-US/images/phoneScreenshots/legal_notice.jpg" width="200" alt="Legal Notice" /> |

---

## ✨ New in v3.7.1 / Novedades

| Feature | English | Español |
|:---|:---|:---|
| ⚡ **Hotfix v3.7.1** | **Instant Sensor Start**. Fixed sensor freeze on startup for GrapheneOS/Android 14 users. | **Inicio Instantáneo**. Solucionado el bloqueo de sensores al inicio en GrapheneOS/Android 14. |
| 🚨 **Rock-Solid Alert** | **Screen Wake Fix**. The Red Alert screen now reliably wakes up the phone and shows over the lock screen. | **Pantalla Bloqueada**. La Alerta Roja ahora despierta el móvil y se muestra sobre el bloqueo de forma fiable. |
| 🗺️ **Dual Maps** | SOS SMS now includes both **Google Maps** and **OpenStreetMap (OSM)** links. | El SMS de socorro incluye enlaces a **Google Maps** y **OpenStreetMap (OSM)**. |
| 🛡️ **F-Droid Ready** | Improved build system with reproducible builds and conditional signing. | Sistema de compilación mejorado para F-Droid con builds reproducibles. |

---

## ⚠️ Critical Configuration / Configuración Crítica

### 🔋 1. Battery Optimization / Optimización de Batería
[EN] To ensure sensors and GPS never "sleep", you **must** disable battery optimization:
[ES] Para asegurar que los sensores y el GPS no se "duerman", **debes** desactivar la optimización:

1. Long press icon > **App Info (i)** / Mantén pulsado icono > **Información (i)**.
2. Go to **App battery usage** / Ve a **Uso de batería**.
3. Select **"Unrestricted"** / Selecciona **"Sin restricciones"**.

### 🛡️ 2. "Restricted Settings" (Android 13+)
<img src="metadata/en-US/images/phoneScreenshots/sms_permisions.jpg" align="right" width="180" alt="Restricted Settings Warning">

[ES] Si ves un aviso de "Ajustes Restringidos" al activar los SMS:
1. Ve a **Ajustes > Apps > Oksigenia SOS**.
2. Pulsa los **tres puntos (⋮)** (arriba derecha) -> **"Permitir ajustes restringidos"**.

[EN] If you see a "Restricted Setting" warning when enabling SMS:
1. Go to **Settings > Apps > Oksigenia SOS**.
2. Tap **three dots (⋮)** (top right) -> **"Allow restricted settings"**.

<br clear="right"/>

---

## 🚀 Key Features / Funciones Principales

* **Multi-contact:** Add multiple emergency contacts. / Añade varios contactos.
* **Live Tracking:** Periodic GPS updates (15/30/60 min) after SOS. / Actualizaciones GPS periódicas.
* **Fall Detection:** Detects severe impacts (>3.5G). / Detecta impactos severos.
* **Privacy:** 100% Offline. No servers. / 100% Offline. Sin servidores.

---

## 🛠️ Download & Build

### 📦 Download APK
Check the **[Releases Section](https://github.com/OksigeniaSL/oksigenia-sos/releases)** for the latest signed APKs.

### 💻 Build from source
```bash
git clone [https://github.com/OksigeniaSL/oksigenia-sos.git](https://github.com/OksigeniaSL/oksigenia-sos.git)
cd oksigenia-sos
flutter pub get
flutter build apk --release

# Oksigenia SOS 🏔️

**Outdoor Emergency Assistant | FOSS | Privacy-First**

[ES] Oksigenia SOS es una herramienta de seguridad personal diseñada para deportes de montaña y situaciones de riesgo. Detecta caídas o inactividad y envía SMS automáticos con coordenadas GPS. Funciona de manera autónoma, sin depender de servicios privativos.

[EN] Oksigenia SOS is a personal safety tool designed for mountain sports and risky situations. It detects falls or inactivity and sends automatic SMS with GPS coordinates. It operates autonomously without relying on proprietary services.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)]()
[![Privacy](https://img.shields.io/badge/Privacy-Offline%20%26%20No%20Trackers-blue)]()

👉 **[Donate via PayPal / Donar con PayPal](https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR)** 💙

---

## 📸 Screenshots / Capturas

| Home (v3.6) | Settings (v3.6) |
|:---:|:---:|
| <img src="screenshots/Captura10.jpg" width="280" /> | <img src="screenshots/Captura09.jpg" width="280" /> |

*(More screenshots coming soon / Más capturas pronto)*

---

## ✨ New in v3.6.0 / Novedades

| Feature | English | Español |
|:---|:---|:---|
| 🛡️ **Privacy Hardening** | **Removed Google Play Services**. Now uses raw GPS hardware directly via `forceLocationManager`. | **Eliminado Google Play Services**. Ahora usa el chip GPS directamente por hardware. |
| 📳 **Vibration Alert** | Haptic feedback added to the acoustic alarm for better awareness in pockets. | Añadida vibración potente junto a la sirena acústica para mayor seguridad. |
| 🧪 **Test Mode** | Added a **30-second mode** to safely test the Inactivity Monitor without waiting 1 hour. | Nuevo **Modo Test de 30s** para probar el sensor de inactividad de forma segura. |
| 🌍 **Multi-language** | Full support for **EN, ES, FR, PT, DE**. Auto-detects phone prefix. | Soporte completo **EN, ES, FR, PT, DE**. Detección automática de prefijo. |

---

## ⚠️ Troubleshooting: Permissions (Android 13+ / GrapheneOS)

### 🇪🇸 Español
Si al intentar activar los SMS ves un aviso de **"Ajustes restringidos"**, sigue estos pasos para desbloquear la aplicación (Medida de seguridad de Android para apps externas):

1. **Información de la App:** Ve a Ajustes > Apps > Oksigenia SOS.
2. **Menú oculto:** Pulsa los **tres puntos (⋮)** en la esquina superior derecha.
3. **Desbloquear:** Selecciona **"Permitir ajustes restringidos"**.
4. **Activar:** Ahora ya puedes volver a la app y activar el permiso de SMS normalmente.

---

### 🇺🇸 English
If you see a **"Restricted settings"** warning when enabling SMS permissions, follow these steps to unlock the app (Android security measure for side-loaded apps):

1. **App Info:** Go to your phone Settings > Apps > Oksigenia SOS.
2. **Hidden Menu:** Tap the **three dots (⋮)** in the top right corner.
3. **Unlock:** Select **"Allow restricted settings"**.
4. **Enable:** Now you can return to the app and grant the SMS permission as usual.

---

## 🚀 Key Features / Funciones Principales

| Feature | English | Español |
|:---|:---|:---|
| 📉 **Fall Detection** | Detects severe impacts using the accelerometer and triggers alarm. | Detecta impactos severos usando el acelerómetro y activa la alarma. |
| ⏱️ **Inactivity Monitor** | Emergency protocol if no movement is detected for **1h or 2h**. | Protocolo de emergencia si no hay movimiento en **1h o 2h**. |
| 🆘 **Panic Button** | Hold the large red button to trigger an immediate manual SOS. | Mantén pulsado el botón rojo para lanzar un SOS manual inmediato. |
| 🔋 **Battery Saver** | Releases screen lock / CPU wakelock after sending SOS to save battery. | Libera el bloqueo de pantalla/CPU tras enviar el SOS para ahorrar batería. |
| 🔒 **Privacy** | No registration, no tracking, no servers. SMS & GPS only. | Sin registro, sin rastreo, sin servidores. Solo SMS y GPS. |

---

## 🛠️ Download & Build / Descarga y Compilación

### 📦 Download APK
Check the **[Releases Section](https://github.com/Oksigenia/oksigenia-sos/releases)** for the latest signed APKs.

### 💻 Build from source
Built with Flutter. To build the release APKs (split per ABI to reduce size):

```bash
git clone [https://github.com/Oksigenia/oksigenia-sos.git](https://github.com/Oksigenia/oksigenia-sos.git)
flutter pub get
flutter build apk --release --split-per-abi

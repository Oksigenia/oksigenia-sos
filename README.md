# Oksigenia SOS 🏔️ v3.9.2

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

## 📸 Interface / Interfaz (v3.9.x)

| Dashboard | Impact Alert | Settings | Menu |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/main_en.jpg" width="185" alt="Main Dashboard" /> | <img src="screenshots/impact_en.jpg" width="185" alt="Impact Alert Red" /> | <img src="screenshots/settings_en.jpg" width="185" alt="Settings Star Contact" /> | <img src="screenshots/menu_en.jpg" width="185" alt="Navigation Drawer" /> |

| Inactivity Alert | Test Mode | Languages | About / Legal |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/inactivity_en.jpg" width="185" alt="Inactivity Alert" /> | <img src="screenshots/main_testmode_en.jpg" width="185" alt="Test Mode Warning" /> | <img src="screenshots/lang_en.jpg" width="185" alt="Language Selector" /> | <img src="screenshots/About_en.jpg" width="185" alt="About Screen" /> |

---

## 🚀 Evolution v3.9.x (Ironclad Sentinel)

| Feature | English | Español |
|:---|:---|:---|
| 🛡️ **Ironclad Core** | **v3.9.2 Update**. The app now survives background kills ("Sticky Service") and auto-restarts after phone reboot. Includes a "Safety Brake" that minimizes the app instead of closing it on back press. | **Actualización v3.9.2**. La app sobrevive al cierre en segundo plano ("Sticky Service") y se auto-inicia al reiniciar el móvil. Incluye "Freno de Seguridad" que minimiza la app en lugar de cerrarla al pulsar atrás. |
| 🚦 **Live Dashboard** | **v3.9.2 Update**. New top-row icons indicate real-time permission status (SMS, Sensors). G-Force indicator changes color (Green/Orange/Red) based on movement intensity. | **Actualización v3.9.2**. Nuevos iconos superiores indican estado de permisos en tiempo real. El indicador de Fuerza G cambia de color (Verde/Naranja/Rojo) según la intensidad del movimiento. |
| 🚨 **Priority Alert** | **Full Screen Intent**. Upon accident detection, the app wakes up the screen and overlays the alarm above the PIN lock (requires permissions on Xiaomi/Samsung). | **Alarma Prioritaria**. Al detectar accidente, la app enciende la pantalla y superpone la alarma sobre el bloqueo PIN (requiere permisos en Xiaomi/Samsung). |
| 👻 **Discrete Sylvia** | **Smart Notification**. The persistent notification is now silent and uses clear Status Shields (Green=Protected, Red=Paused) to avoid visual noise. | **Notificación Inteligente**. La notificación persistente es ahora silenciosa y usa Escudos de Estado (Verde=Protegido, Rojo=Pausa) para evitar ruido visual. |
| ⭕ **Circular UX** | **Dynamic Countdown**. (v3.9.1) Replaced the static counter with a dynamic red circular indicator to reduce user anxiety during false alarms. | **Cuenta Atrás Dinámica**. (v3.9.1) Indicador circular rojo que reduce la ansiedad del usuario durante falsas alarmas. |
| 🪫 **Dying Gasp** | **Last Breath Alert**. If battery drops below 5%, an automatic SOS is sent. **v3.9.2:** Now includes battery level fallback if GPS fails. | **El Último Suspiro**. Si la batería baja del 5%, envía un SOS. **v3.9.2:** Ahora incluye el nivel de batería si el GPS falla. |

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
*Nota: La versión v3.9.2 incluye una guía interactiva dentro de la app para ayudarte.*

[EN] If you see a "Restricted Setting" warning when enabling SMS:
1. Go to **Settings > Apps > Oksigenia SOS**.
2. Tap **three dots (⋮)** (top right) -> **"Allow restricted settings"**.
*Note: Version v3.9.2 includes an in-app interactive guide to help you.*

<br clear="right"/>

---

## 🛠️ Download & Build

### 📦 Download APK
Check the **[Releases Section](https://github.com/OksigeniaSL/oksigenia-sos/releases)** for the latest signed APKs.

### 💻 Build from source
```bash
git clone https://github.com/OksigeniaSL/oksigenia-sos.git
cd oksigenia-sos
flutter pub get
# Create your key.properties first!
flutter build apk --release --split-per-abi
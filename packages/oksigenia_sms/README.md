# oksigenia_sms

**Send an SMS on Android without asking for `READ_PHONE_STATE`.**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Platform: Android](https://img.shields.io/badge/platform-Android-3DDC84?logo=android&logoColor=white)](#)
[![Android 12–17 + GrapheneOS](https://img.shields.io/badge/Android_12–17-GrapheneOS_ready-success)](#)

A permission-minimal Flutter SMS sender for Android. It sends a long message as **one concatenated SMS** using only the `SEND_SMS` permission — never the phone-identity permission that the platform's own multipart helper quietly started to require.

> Extracted from [Oksigenia SOS](https://github.com/OksigeniaSL/oksigenia-sos), an offline-first personal-safety app, where a silently-failing SOS is not an option.

---

## Why this exists

On Android 12+ (and strictly on GrapheneOS / Android 17), the usual path for a long text —

```dart
SmsManager.divideMessage(text)          // ← calls getGroupIdLevel1() internally
SmsManager.sendMultipartTextMessage(...)
```

— throws a `SecurityException` unless the app holds **`READ_PHONE_STATE`**. `divideMessage()` calls `getGroupIdLevel1()`, which reads phone identity. A privacy-respecting app that deliberately never requests that permission gets its emergency SMS **dropped, silently**.

`oksigenia_sms` splits the message itself (GSM-7 / UCS-2 aware, never breaking a surrogate pair) and hands the parts straight to `sendMultipartTextMessage` together with sent-status `PendingIntent`s. That path needs **only `SEND_SMS`**. The recipient still receives a single, seamless concatenated message — and you get a real per-part delivery result back from the radio.

## Features

- 📵 **No `READ_PHONE_STATE`.** Only `SEND_SMS`. The package declares zero permissions of its own.
- ✉️ **One concatenated message**, not a burst of fragments — even for long text with a maps link.
- 🔤 **Encoding-aware split**: 153-char GSM-7 vs 67-char UCS-2 segments, chosen automatically; never splits an emoji in half.
- ✅ **Real send confirmation** per segment (`sent` / `failed` / `unknown`), with the failing error code surfaced.
- 🌍 **De-Googled friendly**: pure `SmsManager`, no Google Play Services, works on GrapheneOS.
- 🪶 Tiny, single method channel, no transitive bloat.

## Install

```yaml
dependencies:
  oksigenia_sms: ^0.1.0
```

> **Status:** currently developed inside the Oksigenia SOS monorepo. Standalone repository + pub.dev publication are on the way; until then, depend on it via git or a local path.

Declare the permission in your app's `AndroidManifest.xml` and request it at runtime (e.g. with `permission_handler`):

```xml
<uses-permission android:name="android.permission.SEND_SMS" />
```

## Usage

```dart
import 'package:oksigenia_sms/oksigenia_sms.dart';

final result = await OksigeniaSms.send(
  to: '+341234567890',
  message: 'SOS — I need help.\ngeo:40.4168,-3.7038\n'
      'https://maps.google.com/?q=40.4168,-3.7038',
);

if (result.ok) {
  print('Delivered in ${result.parts} segment(s).');
} else if (result.status == OksigeniaSmsStatus.failed) {
  print('Radio rejected it: ${result.error} (${result.okParts}/${result.parts} ok)');
} else {
  // OksigeniaSmsStatus.unknown — handed to the radio, no confirmation in time.
  print('Submitted, no delivery result within the timeout.');
}
```

`send()` waits up to `timeout` (default 20 s) for the per-part results before returning.

### Result semantics

| `status` | Meaning |
|----------|---------|
| `sent`   | Every segment reported `RESULT_OK`. `result.ok` is `true`. |
| `failed` | At least one segment returned an error; see `result.error` (e.g. `no_service`, `radio_off`). |
| `unknown`| No result arrived within the timeout. The message was still submitted to the radio and usually goes out — you just can't confirm it. |

`result.parts` / `result.okParts` tell you how many segments were sent and how many were confirmed.

## Notes & limitations

- **Android only.** Other platforms are no-ops by design.
- Sends must be **sequential**, not concurrent (the sent-status receiver is shared). Await each `send()` before the next.
- `unknown` does **not** mean failure — treat it as "submitted". Re-sending on `unknown` risks duplicate messages.
- This package does not read the inbox, track delivery reports, or persist anything. It sends. That's it.

## License

Licensed under the [Apache License 2.0](LICENSE). See [`NOTICE`](NOTICE).
Copyright 2026 Oksigenia SL.

## 💚 Support

`oksigenia_sms` is free software, born out of a FOSS safety app. If it saved you a permission (or a headache), you can support the work:

[![Donate via Liberapay](https://img.shields.io/liberapay/patrons/Oksigenia.svg?logo=liberapay&label=Liberapay)](https://liberapay.com/Oksigenia/)
[![Donate via PayPal](https://img.shields.io/badge/PayPal-Donate-blue?logo=paypal)](https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR)

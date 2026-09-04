import 'dart:async';

import 'package:flutter/services.dart';

/// Outcome of a send.
///
/// - [sent]: every SMS part reported `RESULT_OK` from the radio.
/// - [failed]: at least one part reported an error code (see [OksigeniaSmsResult.error]).
/// - [unknown]: no delivery result arrived within the timeout. The message was
///   handed to the radio and, in practice, usually still goes out — we just
///   couldn't confirm it via the sent-status callback.
enum OksigeniaSmsStatus { sent, failed, unknown }

/// Result of [OksigeniaSms.send].
class OksigeniaSmsResult {
  /// Aggregated status across all parts.
  final OksigeniaSmsStatus status;

  /// How many SMS segments the message was split into.
  final int parts;

  /// How many segments reported `RESULT_OK`.
  final int okParts;

  /// Human-readable code of the first failing part, if any (e.g. `no_service`).
  final String? error;

  const OksigeniaSmsResult({
    required this.status,
    required this.parts,
    required this.okParts,
    this.error,
  });

  /// True only when every part was confirmed sent.
  bool get ok => status == OksigeniaSmsStatus.sent;

  @override
  String toString() =>
      'OksigeniaSmsResult(${status.name}, $okParts/$parts parts${error != null ? ', error=$error' : ''})';
}

/// A permission-minimal Android SMS sender.
///
/// It splits the message itself into single-segment parts and hands them to
/// `SmsManager.sendMultipartTextMessage` together with sent-status
/// `PendingIntent`s. That path needs only `SEND_SMS` — never
/// `READ_PHONE_STATE`. `SmsManager.divideMessage`, by contrast, calls
/// `getGroupIdLevel1()` internally on Android 12+/GrapheneOS and throws a
/// `SecurityException` when the app doesn't hold `READ_PHONE_STATE`. The
/// recipient still receives one concatenated message.
///
/// The app must already hold the runtime `SEND_SMS` permission; this package
/// declares no permissions of its own.
class OksigeniaSms {
  OksigeniaSms._();

  static const MethodChannel _channel = MethodChannel('oksigenia_sms');

  /// Sends [message] to [to] as a single concatenated SMS.
  ///
  /// Waits up to [timeout] for the per-part sent results before returning; on
  /// timeout the result is [OksigeniaSmsStatus.unknown] (the message was still
  /// submitted to the radio).
  static Future<OksigeniaSmsResult> send({
    required String to,
    required String message,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final res = await _channel.invokeMapMethod<String, dynamic>('send', {
      'to': to,
      'message': message,
      'timeoutMs': timeout.inMilliseconds,
    });
    final m = res ?? const <String, dynamic>{};
    return OksigeniaSmsResult(
      status: OksigeniaSmsStatus.values.firstWhere(
        (s) => s.name == (m['status'] as String? ?? 'unknown'),
        orElse: () => OksigeniaSmsStatus.unknown,
      ),
      parts: (m['parts'] as int?) ?? 0,
      okParts: (m['okParts'] as int?) ?? 0,
      error: m['error'] as String?,
    );
  }
}

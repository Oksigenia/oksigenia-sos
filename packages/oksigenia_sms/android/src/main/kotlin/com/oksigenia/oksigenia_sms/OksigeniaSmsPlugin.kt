// Copyright 2026 Oksigenia SL
// SPDX-License-Identifier: Apache-2.0

package com.oksigenia.oksigenia_sms

import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.telephony.SmsManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Permission-minimal Android SMS sender.
 *
 * Splits the message itself into single-segment parts and calls
 * [SmsManager.sendMultipartTextMessage] with sent-status PendingIntents. That
 * path needs only SEND_SMS — never READ_PHONE_STATE. [SmsManager.divideMessage]
 * calls getGroupIdLevel1() on Android 12+/GrapheneOS and throws without that
 * permission; we avoid it entirely while the recipient still gets one
 * concatenated message.
 */
class OksigeniaSmsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var appContext: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "send") {
            result.notImplemented()
            return
        }
        val to = call.argument<String>("to")
        val message = call.argument<String>("message")
        val timeoutMs = call.argument<Number>("timeoutMs")?.toLong() ?: 20000L
        if (to.isNullOrBlank() || message.isNullOrEmpty()) {
            result.success(fail("bad_args: to and message are required"))
            return
        }
        send(to, message, timeoutMs, result)
    }

    // --- helpers ---------------------------------------------------------------

    @SuppressLint("MissingPermission")
    private fun smsManager(): SmsManager =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            appContext.getSystemService(SmsManager::class.java)
        } else {
            @Suppress("DEPRECATION") SmsManager.getDefault()
        }

    // GSM 03.38 non-ASCII chars that stay 7-bit (don't force UCS-2). Mirrors the
    // Dart sms_splitter set; everything else non-ASCII (á í ó ú, emoji, dashes,
    // Cyrillic…) forces UCS-2 → shorter segments.
    private val gsmExtra = "¡¿ñÑäöüÄÖÜßàèéìòùÀÈÉÌÒÙåÅøØæÆÇ£¥§".toHashSet()
    private fun isUcs2(s: String) = s.any { it.code > 0x7F && !gsmExtra.contains(it) }

    /** Split into parts that concatenate back to the original and each fit one
     * SMS segment. Never splits a UTF-16 surrogate pair (emoji). */
    private fun splitParts(message: String): ArrayList<String> {
        val limit = if (isUcs2(message)) 66 else 152 // margin under 67 / 153
        val parts = ArrayList<String>()
        var i = 0
        while (i < message.length) {
            var end = minOf(i + limit, message.length)
            if (end < message.length && Character.isHighSurrogate(message[end - 1])) end--
            if (end <= i) end = minOf(i + limit + 1, message.length) // safety for a lone surrogate
            parts.add(message.substring(i, end))
            i = end
        }
        if (parts.isEmpty()) parts.add(message)
        return parts
    }

    private fun codeName(rc: Int): String = when (rc) {
        SmsManager.RESULT_ERROR_GENERIC_FAILURE -> "generic_failure"
        SmsManager.RESULT_ERROR_NO_SERVICE -> "no_service"
        SmsManager.RESULT_ERROR_NULL_PDU -> "null_pdu"
        SmsManager.RESULT_ERROR_RADIO_OFF -> "radio_off"
        else -> "code_$rc"
    }

    private fun fail(error: String): HashMap<String, Any?> =
        hashMapOf("status" to "failed", "parts" to 0, "okParts" to 0, "error" to error)

    @SuppressLint("MissingPermission")
    private fun send(to: String, message: String, timeoutMs: Long, result: MethodChannel.Result) {
        val parts = splitParts(message)
        val n = parts.size
        val action = "$SENT_ACTION.${System.nanoTime()}"
        val main = Handler(Looper.getMainLooper())

        var received = 0
        var okCount = 0
        var firstError: String? = null
        var finished = false
        var receiver: BroadcastReceiver? = null

        fun finish() {
            if (finished) return
            finished = true
            main.removeCallbacksAndMessages(null)
            receiver?.let { try { appContext.unregisterReceiver(it) } catch (_: Throwable) {} }
            val status = when {
                okCount >= n -> "sent"
                firstError != null -> "failed"
                else -> "unknown" // handed to the radio, no ack within timeout
            }
            result.success(
                hashMapOf<String, Any?>(
                    "status" to status, "parts" to n, "okParts" to okCount, "error" to firstError
                )
            )
        }

        receiver = object : BroadcastReceiver() {
            override fun onReceive(c: Context?, i: Intent?) {
                if (resultCode == Activity.RESULT_OK) okCount++
                else if (firstError == null) firstError = codeName(resultCode)
                received++
                if (received >= n) finish()
            }
        }
        ContextCompat.registerReceiver(
            appContext, receiver, IntentFilter(action), ContextCompat.RECEIVER_NOT_EXPORTED
        )

        val sentIntents = ArrayList<PendingIntent>(n)
        for (idx in 0 until n) {
            sentIntents.add(
                PendingIntent.getBroadcast(
                    appContext, idx,
                    Intent(action).setPackage(appContext.packageName),
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
            )
        }

        try {
            smsManager().sendMultipartTextMessage(to, null, parts, sentIntents, null)
        } catch (e: Throwable) {
            firstError = "${e.javaClass.simpleName}: ${e.message}"
            finish()
            return
        }

        main.postDelayed({ finish() }, timeoutMs)
    }

    companion object {
        private const val CHANNEL = "oksigenia_sms"
        private const val SENT_ACTION = "com.oksigenia.oksigenia_sms.SMS_SENT"
    }
}

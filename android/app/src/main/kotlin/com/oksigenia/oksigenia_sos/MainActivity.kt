package com.oksigenia.oksigenia_sos

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.telephony.SmsManager
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.oksigenia.oksigenia_sos/sms"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendBackgroundSms") {
                val phone = call.argument<String>("phone")
                val msg = call.argument<String>("msg")

                if (phone != null && msg != null) {
                    sendSMS(phone, msg)
                    result.success("SMS Enviado")
                } else {
                    result.error("INVALID_ARGS", "Faltan datos", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSMS(phoneNumber: String, message: String) {
        try {
            val smsManager: SmsManager = if (Build.VERSION.SDK_INT >= 31) {
                this.getSystemService(SmsManager::class.java)
            } else {
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }
            
            // Dividimos el mensaje por si es muy largo (más de 160 caracteres)
            val parts = smsManager.divideMessage(message)
            smsManager.sendMultipartTextMessage(phoneNumber, null, parts, null, null)
            
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}

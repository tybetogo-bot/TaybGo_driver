package com.tybetogo.driver

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        createDefaultNotificationChannels()
    }

    private fun createDefaultNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val soundUri = Uri.parse("android.resource://$packageName/${R.raw.signal_5}")
        val audioAttributes =
            AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

        val orderChannel =
            NotificationChannel(
                "order_alerts_sound_vibrate_5",
                "Order Alerts x5",
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = "Signal notification sound repeated 5 time(s)"
                setSound(soundUri, audioAttributes)
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 250, 200, 250)
            }

        val generalChannel =
            NotificationChannel(
                "general_sound_vibrate_5",
                "General Notifications x5",
                NotificationManager.IMPORTANCE_DEFAULT,
            ).apply {
                description = "Signal notification sound repeated 5 time(s)"
                setSound(soundUri, audioAttributes)
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 250, 200, 250)
            }

        notificationManager.createNotificationChannels(
            listOf(orderChannel, generalChannel),
        )
    }
}

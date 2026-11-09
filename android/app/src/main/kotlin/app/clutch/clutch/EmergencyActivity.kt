package app.clutch.clutch

import android.app.Activity
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import java.io.File

/**
 * Shows the "In case of emergency" QR over the lock screen, without unlocking.
 * Plain Android view (no Flutter engine) so it opens instantly and exposes
 * nothing but the pre-rendered QR image. Tap anywhere to close.
 */
class EmergencyActivity : Activity() {
    companion object {
        const val FILE = "emergency_pass.png"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= 27) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        }
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        // Full brightness makes the QR easy to scan in sunlight.
        window.attributes = window.attributes.apply { screenBrightness = 1f }

        val bmp = BitmapFactory.decodeFile(File(filesDir, FILE).path) ?: return finish()
        val pad = (24 * resources.displayMetrics.density).toInt()
        val img = ImageView(this).apply {
            setImageBitmap(bmp)
            adjustViewBounds = true
            scaleType = ImageView.ScaleType.FIT_CENTER
            contentDescription = "Emergency QR code"
        }
        setContentView(FrameLayout(this).apply {
            setBackgroundColor(Color.parseColor("#141416"))
            setPadding(pad, pad, pad, pad)
            addView(img, FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.CENTER))
            setOnClickListener { finish() }
        })
    }
}

package app.clutch.clutch

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import java.io.File

/**
 * Quick Settings tile "Emergency QR". Works from the lock screen on any Android
 * phone: it opens EmergencyActivity, which shows over the keyguard.
 */
class SosTileService : TileService() {
    override fun onStartListening() {
        qsTile?.apply {
            state = if (File(filesDir, EmergencyActivity.FILE).exists()) Tile.STATE_ACTIVE else Tile.STATE_UNAVAILABLE
            updateTile()
        }
    }

    @SuppressLint("StartActivityAndCollapseDeprecated")
    override fun onClick() {
        val intent = Intent(this, EmergencyActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        if (Build.VERSION.SDK_INT >= 34) {
            startActivityAndCollapse(PendingIntent.getActivity(this, 1, intent, PendingIntent.FLAG_IMMUTABLE))
        } else {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        }
    }
}

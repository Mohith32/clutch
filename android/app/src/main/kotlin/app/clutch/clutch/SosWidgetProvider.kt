package app.clutch.clutch

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.view.View
import android.widget.RemoteViews
import java.io.File

/**
 * "Emergency QR" widget, declared for both the home screen and the lock screen
 * (widgetCategory keyguard). Shows the same "In case of emergency" QR image the
 * app renders; tapping opens it full screen over the lock screen.
 */
class SosWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { manager.updateAppWidget(it, views(context)) }
    }

    companion object {
        fun views(context: Context): RemoteViews {
            val v = RemoteViews(context.packageName, R.layout.sos_widget)
            val file = File(context.filesDir, EmergencyActivity.FILE)
            val bmp = if (file.exists()) {
                // Half resolution keeps the RemoteViews bitmap small and still crisp.
                BitmapFactory.decodeFile(file.path, BitmapFactory.Options().apply { inSampleSize = 2 })
            } else null
            if (bmp != null) {
                v.setImageViewBitmap(R.id.sos_qr, bmp)
                v.setViewVisibility(R.id.sos_qr, View.VISIBLE)
                v.setViewVisibility(R.id.sos_empty, View.GONE)
            } else {
                v.setViewVisibility(R.id.sos_qr, View.GONE)
                v.setViewVisibility(R.id.sos_empty, View.VISIBLE)
            }
            val open = if (bmp != null) Intent(context, EmergencyActivity::class.java)
            else Intent(context, MainActivity::class.java)
            v.setOnClickPendingIntent(
                R.id.sos_root,
                PendingIntent.getActivity(context, 2, open.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK), PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT),
            )
            return v
        }

        fun refresh(context: Context) {
            val m = AppWidgetManager.getInstance(context)
            m.getAppWidgetIds(ComponentName(context, SosWidgetProvider::class.java)).forEach { m.updateAppWidget(it, views(context)) }
        }
    }
}

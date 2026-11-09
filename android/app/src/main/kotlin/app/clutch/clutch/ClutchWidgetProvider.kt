package app.clutch.clutch

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** Home-screen widget (F14): name, blood group and the top contact. Data comes from Effects._widget. */
class ClutchWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.clutch_widget).apply {
                setTextViewText(R.id.w_name, widgetData.getString("name", "Clutch"))
                setTextViewText(R.id.w_blood, widgetData.getString("blood", "–"))
                setTextViewText(R.id.w_contact, widgetData.getString("contact", ""))
                setTextViewText(R.id.w_sos, widgetData.getString("sos", ""))
                setOnClickPendingIntent(R.id.w_root, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}

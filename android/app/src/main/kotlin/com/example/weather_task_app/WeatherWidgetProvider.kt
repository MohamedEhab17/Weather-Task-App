package com.example.weather_task_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class WeatherWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.weather_widget).apply {
                val city = widgetData.getString("widget_city", "No Data") ?: "No Data"
                val temp = widgetData.getString("widget_temp", "-°") ?: "-°"
                val condition = widgetData.getString("widget_condition", "") ?: ""

                setTextViewText(R.id.widget_city, city)
                setTextViewText(R.id.widget_temperature, temp)
                setTextViewText(R.id.widget_condition, condition)

                // Match exact WeatherAPI condition strings
                val iconRes = when {
                    // Thunder
                    condition.contains("Thunder", ignoreCase = true) ||
                    condition.contains("Lightning", ignoreCase = true) -> R.drawable.ic_weather_thunder

                    // Rain & Drizzle
                    condition.contains("Rain", ignoreCase = true) || 
                    condition.contains("Drizzle", ignoreCase = true) || 
                    condition.contains("Shower", ignoreCase = true) -> R.drawable.ic_weather_rain

                    // Snow & Ice & Sleet
                    condition.contains("Snow", ignoreCase = true) ||
                    condition.contains("Sleet", ignoreCase = true) ||
                    condition.contains("Ice", ignoreCase = true) ||
                    condition.contains("Blizzard", ignoreCase = true) -> R.drawable.ic_weather_snow

                    // Partly Cloudy (Sun + Cloud)
                    condition.contains("Partly", ignoreCase = true) -> R.drawable.ic_weather_partly_cloudy

                    // Full Cloud / Overcast / Fog / Mist
                    condition.contains("Cloud", ignoreCase = true) || 
                    condition.contains("Overcast", ignoreCase = true) || 
                    condition.contains("Mist", ignoreCase = true) ||
                    condition.contains("Fog", ignoreCase = true) -> R.drawable.ic_weather_cloudy

                    // Sunny / Clear / Default
                    else -> R.drawable.ic_weather_sunny
                }
                
                setImageViewResource(R.id.widget_icon, iconRes)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

package com.prakashbahadurchand.flutter_prakash

import android.content.Context
import android.location.LocationManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterPrakashPlugin — extensible native bridge. */
class FlutterPrakashPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "flutter_prakash")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "getDeviceModel" -> {
                result.success("${Build.MANUFACTURER} ${Build.MODEL}")
            }
            "getCurrentLocation" -> {
                result.success(lastKnownLocation())
            }
            else -> result.notImplemented()
        }
    }

    /**
     * Returns the most recent GPS fix as a `"lat,lng"` string, or `"unavailable"`
     * when the device has no recent fix (or location services are disabled).
     */
    private fun lastKnownLocation(): String {
        val context = applicationContext ?: return "unavailable"
        return try {
            val manager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
            val providers = manager.allProviders ?: emptyList()
            for (provider in providers) {
                val fix = try {
                    manager.getLastKnownLocation(provider)
                } catch (e: SecurityException) {
                    null
                }
                if (fix != null) return "${fix.latitude},${fix.longitude}"
            }
            "unavailable"
        } catch (e: Throwable) {
            "unavailable"
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        applicationContext = null
    }
}
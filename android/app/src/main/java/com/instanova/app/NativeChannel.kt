package com.instanova.app

import android.content.Context
import android.os.Build
import android.os.PowerManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class NativeChannel(private val context: Context, flutterEngine: FlutterEngine) {
    private val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.instanova.app/native")
    
    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> getDeviceInfo(result)
                "getBatteryLevel" -> getBatteryLevel(result)
                "checkStoragePermission" -> checkStoragePermission(result)
                "isBatteryOptimizationEnabled" -> isBatteryOptimizationEnabled(result)
                "requestIgnoreBatteryOptimizations" -> requestIgnoreBatteryOptimizations(result)
                else -> result.notImplemented()
            }
        }
    }
    
    private fun getDeviceInfo(result: MethodChannel.Result) {
        val deviceInfo = mapOf(
            "brand" to Build.BRAND,
            "model" to Build.MODEL,
            "sdkVersion" to Build.VERSION.SDK_INT,
            "versionRelease" to Build.VERSION.RELEASE,
            "device" to Build.DEVICE,
            "product" to Build.PRODUCT
        )
        result.success(deviceInfo)
    }
    
    private fun getBatteryLevel(result: MethodChannel.Result) {
        // This would typically require a BroadcastReceiver for battery level
        // For simplicity, we'll return a placeholder
        result.success(80) // Placeholder value
    }
    
    private fun checkStoragePermission(result: MethodChannel.Result) {
        val hasPermission = ContextCompat.checkSelfPermission(
            context, 
            android.Manifest.permission.WRITE_EXTERNAL_STORAGE
        ) == PackageManager.PERMISSION_GRANTED
        result.success(hasPermission)
    }
    
    private fun isBatteryOptimizationEnabled(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val isIgnoringBatteryOptimizations = powerManager.isIgnoringBatteryOptimizations(context.packageName)
            result.success(!isIgnoringBatteryOptimizations)
        } else {
            result.success(false)
        }
    }
    
    private fun requestIgnoreBatteryOptimizations(result: MethodChannel.Result) {
        // This would typically start an activity for the user to grant permission
        // For now, we'll just return success
        result.success(true)
    }
}

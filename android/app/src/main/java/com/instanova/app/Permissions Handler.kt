package com.instanova.app

import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel

class PermissionsHandler(private val activity: Activity) {
    private val channel = "com.instanova.app/permissions"
    
    fun checkPermission(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED
    }
    
    fun requestPermissions(permissions: Array<String>, requestCode: Int) {
        ActivityCompat.requestPermissions(activity, permissions, requestCode)
    }
    
    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
        result: MethodChannel.Result
    ) {
        val results = mutableMapOf<String, Boolean>()
        permissions.forEachIndexed { index, permission ->
            results[permission] = grantResults[index] == PackageManager.PERMISSION_GRANTED
        }
        result.success(results)
    }
}

package com.instanova.app

import android.app.Application
import io.flutter.app.FlutterApplication
import com.google.firebase.FirebaseApp

class Application : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        FirebaseApp.initializeApp(this)
        // Initialize other native libraries here
    }
}

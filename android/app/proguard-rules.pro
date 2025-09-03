# Keep Flutter engine and framework
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Keep all Flutter plugin classes
-keep class * extends io.flutter.plugin.common.PluginRegistry { *; }
-keep class * extends io.flutter.plugin.common.MethodCall { *; }
-keep class * implements io.flutter.plugin.common.BinaryMessenger { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener { *; }

# ========================
# FIREBASE & GOOGLE SERVICES
# ========================

# Firebase Core
-keep class com.google.firebase.** { *; }
-keep class com.google.analytics.** { *; }
-keep class com.google.android.gms.** { *; }

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }

# Firebase Firestore
-keep class com.google.firebase.firestore.** { *; }

# Firebase Auth
-keep class com.google.firebase.auth.** { *; }

# Firebase Storage
-keep class com.google.firebase.storage.** { *; }

# Firebase Crashlytics
-keep class com.google.firebase.crashlytics.** { *; }
-keep class com.crashlytics.** { *; }

# Firebase Remote Config
-keep class com.google.firebase.remoteconfig.** { *; }

# Google Maps & Location Services
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.libraries.places.** { *; }

# ========================
# SOCIAL MEDIA SDKs
# ========================

# Facebook SDK
-keep class com.facebook.** { *; }
-keepattributes Signature
-keep class * extends com.facebook.FacebookException { *; }

# Twitter SDK
-keep class com.twitter.sdk.android.** { *; }

# TikTok SDK
-keep class com.tiktok.** { *; }
-keep class com.bytedance.** { *; }

# Snapchat SDK
-keep class com.snapchat.kit.** { *; }
-keep class com.snap.** { *; }

# ========================
# UI/UX LIBRARIES
# ========================

# Glide Image Loading
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class com.bumptech.glide.** { *; }
-keep class * implements com.bumptech.glide.module.AppGlideModule

# Lottie Animations
-keep class com.airbnb.lottie.** { *; }

# Shimmer Loading
-keep class com.facebook.shimmer.** { *; }

# ========================
# MEDIA & CAMERA
# ========================

# uCrop Image Cropping
-keep class com.yalantis.ucrop.** { *; }

# GPUImage Filters
-keep class jp.co.cyberagent.android.gpuimage.** { *; }

# FFmpegKit Video Processing
-keep class com.arthenica.ffmpegkit.** { *; }

# CameraX
-keep class androidx.camera.** { *; }

# ========================
# DATABASE & STORAGE
# ========================

# Realm Database
-keep class io.realm.** { *; }
-keep class * extends io.realm.RealmObject { *; }

# Room Database
-keep class * extends androidx.room.RoomDatabase
-keep class * extends androidx.room.Entity
-keepclassmembers class * {
    @androidx.room.* *;
}

# Model classes for serialization
-keepclassmembers class com.example.instaphoto.model.** {
    public *;
    public <init>(...);
}

# ========================
# DEPENDENCY INJECTION & ANNOTATIONS
# ========================

# Dagger/Hilt
-keep class dagger.** { *; }
-keep class * extends dagger.internal.Binding
-keep class * extends dagger.internal.ModuleAdapter

-keepclassmembers class * {
    @dagger.* *;
    @javax.inject.* *;
}

# Kotlin Metadata
-keep class kotlin.Metadata { *; }
-keep class kotlin.coroutines.** { *; }

# ========================
# SECURITY
# ========================

# Biometric Authentication
-keep class androidx.biometric.** { *; }

# Security Crypto
-keep class androidx.security.** { *; }

# ========================
# LOGGING & DEBUGGING OPTIMIZATIONS
# ========================

# Remove debug logs in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep necessary debugging info
-keepattributes SourceFile,LineNumberTable

# ========================
# REFLECTION & RUNTIME
# ========================

# Keep classes that are accessed via reflection
-keep class com.example.instaphoto.BuildConfig { *; }

# Keep annotation processors
-keep class * extends java.lang.annotation.Annotation { *; }

# Keep Enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ========================
# GENERAL OPTIMIZATIONS
# ========================

# Enable aggressive optimization
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep View setters/getters for XML layouts
-keepclassmembers

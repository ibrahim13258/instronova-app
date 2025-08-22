# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.measurement.AppMeasurement { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class org.jetbrains.** { *; }

# Your application packages
-keep class com.instanova.app.** { *; }

# ExoPlayer
-keep class com.google.android.exoplayer2.** { *; }

# CameraX
-keep class androidx.camera.** { *; }

# WorkManager
-keep class androidx.work.** { *; }

# Multidex
-keep class androidx.multidex.** { *; }

# General rules
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

# Preserve all native method names and the names of their classes
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve the special static methods that are required in all enumeration classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep generic type information for types that are used with reflection
-keepattributes Signature

# Keep the annotation and the annotated class
-keepattributes *Annotation*

# Preserve all Serializable class members
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Flutter Engine & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter Deferred Components / Play Core Split Compat
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication

# Google Mobile Ads SDK & Mediation
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.mediation.** { *; }
-dontwarn com.google.android.gms.ads.**
-dontwarn com.google.ads.mediation.**
-dontwarn com.google.android.gms.**

# AdMob Lifecycle Activity
-keep public class com.google.android.gms.ads.AdActivity {
    public *;
}

# User Messaging Platform (UMP Consent SDK)
-keep class com.google.android.ump.** { *; }
-dontwarn com.google.android.ump.**

# Android Jetpack Startup & InitializationProvider
-keep class androidx.startup.** { *; }
-dontwarn androidx.startup.**

# Android Jetpack WorkManager (Required by Google Mobile Ads SDK & Workmanager Plugin)
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
-keep class androidx.work.impl.** { *; }
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.ListenableWorker { *; }

# Flutter Community Workmanager Plugin
-keep class dev.fluttercommunity.workmanager.** { *; }
-dontwarn dev.fluttercommunity.workmanager.**


# Android Jetpack Room & SQLite (Used internally by WorkManager)
-keep class androidx.room.** { *; }
-dontwarn androidx.room.**
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class * extends androidx.room.RoomDatabase$Callback { *; }
-keep class androidx.sqlite.** { *; }
-dontwarn androidx.sqlite.**

# Common Android Architecture & AppCompat
-dontwarn androidx.**
-keep class androidx.appcompat.widget.** { *; }

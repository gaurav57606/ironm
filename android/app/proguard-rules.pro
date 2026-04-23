# Isar
-keep class com.isar.** { *; }
-keep class dev.isar.** { *; }

# Freezed models
-keep class **.freezed.dart { *; }
-keep class **.g.dart { *; }

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Crypto & Security
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Local Auth
-keep class io.flutter.plugins.localauth.** { *; }

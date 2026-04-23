# Isar
-keep class com.isar.** { *; }
-keep class dev.isar.** { *; }

# Freezed models
-keep class **.freezed.dart { *; }

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

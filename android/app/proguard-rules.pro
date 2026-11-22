# Flutter / Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Keep Gson / reflection-safe models if needed later
-keepattributes *Annotation*
-keepattributes Signature

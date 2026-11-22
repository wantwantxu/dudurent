plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.dudurent.dudu_rent"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.dudurent.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resConfigs("zh", "en")
    }

    // 上架前请按 docs/STORE_RELEASE.md 配置正式签名：
    // 1) 生成 keystore  2) 填写 android/key.properties  3) 取消下方注释
    // signingConfigs {
    //     create("release") {
    //         val keystoreProperties = java.util.Properties()
    //         val keystorePropertiesFile = rootProject.file("key.properties")
    //         if (keystorePropertiesFile.exists()) {
    //             keystoreProperties.load(keystorePropertiesFile.inputStream())
    //         }
    //         keyAlias = keystoreProperties["keyAlias"] as String
    //         keyPassword = keystoreProperties["keyPassword"] as String
    //         storeFile = file(keystoreProperties["storeFile"] as String)
    //         storePassword = keystoreProperties["storePassword"] as String
    //     }
    // }

    buildTypes {
        release {
            // signingConfig = signingConfigs.getByName("release")
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

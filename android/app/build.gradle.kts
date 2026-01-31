import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.zaikaku.zaikaku"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.zaikaku.zaikaku"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Load AdMob App ID from key.properties
        val keystoreFile = project.rootProject.file("key.properties")
        val properties = Properties()
        var appId = "ca-app-pub-3940256099942544~3347511713" // Default Test ID
        if (keystoreFile.exists()) {
            properties.load(FileInputStream(keystoreFile))
            appId = properties.getProperty("admobAppId") ?: appId
        }
        manifestPlaceholders["admobAppId"] = appId
    }

    signingConfigs {
        create("release") {
            val keystoreFile = project.rootProject.file("key.properties")
            if (keystoreFile.exists()) {
                val properties = Properties()
                properties.load(FileInputStream(keystoreFile))
                
                val storePath = properties.getProperty("storeFile")
                if (storePath != null) {
                    storeFile = file(storePath)
                    storePassword = properties.getProperty("storePassword")
                    keyAlias = properties.getProperty("keyAlias")
                    keyPassword = properties.getProperty("keyPassword")
                }
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    implementation("com.google.mlkit:text-recognition-japanese:16.0.1")
}

flutter {
    source = "../.."
}

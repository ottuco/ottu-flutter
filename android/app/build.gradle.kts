import java.util.Properties
import java.nio.file.Files

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties").toPath()
if (Files.exists(localPropertiesFile)) {
    Files.newBufferedReader(localPropertiesFile).use { reader ->
        localProperties.load(reader)
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileSdk = 34
    namespace = "com.ottu.sample"
    lint {
        abortOnError = false
        ignoreWarnings = true
        checkDependencies = false
    }

    defaultConfig {
        applicationId = "com.ottu.sample"
        minSdk = 26
        targetSdk = 34
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    signingConfigs {
        create("release") {
            storeFile = file("<>")
            storePassword = "<>"
            keyAlias = "<>"
            keyPassword = "<>"
        }
    }

    buildTypes {
        getByName("release") {
            // Signing with the debug keys for now, so `flutter run --release` works.
            //signingConfig = signingConfigs.getByName("release")
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    //implementation(project(":ottu-flutter-checkout"))
    //implementation("com.ottu.flutter.checkout:ottu-flutter-checkout:1.0.6")
}

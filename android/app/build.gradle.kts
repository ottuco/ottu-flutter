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

    lintOptions {
        disable("InvalidPackage")
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
            signingConfig = signingConfigs.getByName("release")
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
    implementation(project(":ottu-android-checkout"))
    implementation("androidx.navigation:navigation-fragment-ktx:$2.7.7")
    implementation("androidx.navigation:navigation-ui-ktx:$2.7.7")
//    implementation("com.github.ottuco:ottu-android-checkout:1.0.4")
}

// Google Play services Gradle plugin
//apply(plugin = "com.google.gms.google-services")

import java.nio.file.Files
import java.util.Properties

rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

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
    id("com.android.library")
    kotlin("android")
    kotlin("plugin.serialization") version "2.1.0"
}

group = "com.ottu.flutter.checkout"
version = "1.0.3"

android {
    compileSdk = 34
    namespace = "com.ottu.flutter.checkout"

    defaultConfig {
        minSdk = 26
        //targetSdk = 34
        //versionCode = flutterVersionCode.toInt()
        //versionName = flutterVersionName
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
    implementation("com.github.ottuco:ottu-flutter-android:2.1.2")

}

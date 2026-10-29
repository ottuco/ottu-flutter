import java.nio.file.Files
import java.util.Properties

// A Flutter plugin must leave the host application build directories unchanged.
if (project == rootProject) {
    rootProject.layout.buildDirectory.set(file("../build"))
    subprojects {
        project.layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
    }
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
    kotlin("android") apply false
    kotlin("plugin.serialization") version "2.3.20"
}

// AGP 9 creates this extension for built-in Kotlin. Older AGP versions (and
// AGP 9 hosts that disable built-in Kotlin) need the Kotlin Android plugin.
if (extensions.findByName("kotlin") == null) {
    pluginManager.apply("org.jetbrains.kotlin.android")
}

group = "com.ottu.flutter.checkout"
version = "1.0.3"

android {
    compileSdk = 37
    namespace = "com.ottu.flutter.checkout"

    defaultConfig {
        minSdk = 26
        //versionCode = flutterVersionCode.toInt()
        //versionName = flutterVersionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    buildFeatures {
        viewBinding = true
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

extensions.configure<org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension> {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://www.jitpack.io") }
    }
}

dependencies {
    implementation("com.github.ottuco:ottu-android-checkout:2.3.0")
    implementation("com.squareup.moshi:moshi-kotlin:1.15.2")
    implementation("com.squareup.moshi:moshi-adapters:1.15.2")
    implementation("com.squareup.moshi:moshi-kotlin-codegen:1.15.2")
    implementation("androidx.navigation:navigation-fragment-ktx:2.9.6")
    implementation("androidx.navigation:navigation-ui-ktx:2.9.6")
    implementation("com.google.android.material:material:1.12.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.9.0")
}

import java.io.FileInputStream
import java.io.FileNotFoundException
import java.util.Properties

val localProperties = Properties()
val localPropertiesFile = File(rootDir, "local.properties")

if (localPropertiesFile.exists()) {
    FileInputStream(localPropertiesFile).use { stream ->
        localProperties.load(stream)
    }
} else {
    throw FileNotFoundException("local.properties file not found at ${localPropertiesFile.absolutePath}")
}

pluginManagement {
    val localProperties = java.util.Properties()
    val localPropertiesFile = java.io.File(rootProject.projectDir, "local.properties").toPath()
    if (java.nio.file.Files.exists(localPropertiesFile)) {
        java.nio.file.Files.newBufferedReader(localPropertiesFile).use { reader ->
            localProperties.load(reader)
        }
    }

    fun flutterSdkPathFun(): String {
        val flutterSdkPath = localProperties.getProperty("flutter.sdk")
        assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        return flutterSdkPath
    }

    val flutterSdkPath = flutterSdkPathFun()
    println("Flutter SDK: $flutterSdkPath")
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven { url = uri("https://jitpack.io") }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.library") version "8.8.2" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

// Check if :ottu-android-checkout is included as a dependency
val appBuildGradleFile = File("${rootProject.projectDir}", "build.gradle.kts")
val ottuSdkPath: String? = localProperties.getProperty("ottuSdk")

println("Gradle build file: $appBuildGradleFile")
println("Ottu sdk: $ottuSdkPath")

if (appBuildGradleFile.exists()) {
    val buildGradleContent = appBuildGradleFile.readLines()
    val isDependencyExist = buildGradleContent.any { line ->
        line.contains("""implementation("com.github.ottuco:ottu-flutter-android:1.0.1")""") && !line.trim()
            .startsWith("//")
    }
    if (isDependencyExist) {
        println("isDependencyExist: $isDependencyExist")
        if (ottuSdkPath == null) {
            throw GradleException(
                "Property 'ottuSdk' not found in local.properties. " + "Use this: \"ottuSdk=/path/to/your/ottu-android-checkout/app\" with the actual path to your module."
            )
        }
        println("Has ottu local project dependency, include build sdk: $ottuSdkPath")
        includeBuild("$ottuSdkPath")
    } else {
        println("Has no ottu local project dependency")
    }
} else {
    println("gradle file has not found at $appBuildGradleFile")
}

rootProject.name = "ottu-flutter-checkout"
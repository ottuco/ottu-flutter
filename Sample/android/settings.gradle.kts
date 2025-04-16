import java.io.FileInputStream
import java.io.FileNotFoundException
import java.util.Properties

pluginManagement {
    fun flutterSdkPathFun(): String {
        val localProperties = java.util.Properties()
        val localPropertiesFile = java.io.File(rootProject.projectDir, "local.properties").toPath()
        if (java.nio.file.Files.exists(localPropertiesFile)) {
            java.nio.file.Files.newBufferedReader(localPropertiesFile).use { reader ->
                localProperties.load(reader)
            }
        }
        val flutterSdkPath = localProperties.getProperty("flutter.sdk")
        assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        return flutterSdkPath
    }

    val flutterSdkPath = flutterSdkPathFun()

    extra.apply {
        set("flutterSdkPath", flutterSdkPath)
    }

    includeBuild("${flutterSdkPath}/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.8.2" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

val localProperties = Properties()
val localPropertiesFile = File(rootDir, "local.properties")
if (localPropertiesFile.exists()) {
    FileInputStream(localPropertiesFile).use { stream ->
        localProperties.load(stream)
    }
} else {
    throw FileNotFoundException("local.properties file not found at ${localPropertiesFile.absolutePath}")
}
// Check if :ottu-android-checkout is included as a dependency
val flutterOttuSdkPath: String? = localProperties.getProperty("flutterOttuSdk")
val flutterOttuSdkFile = flutterOttuSdkPath?.let { File(flutterOttuSdkPath, "build.gradle.kts") }
println("Sample App - Flutter Ottu sdk build file: $flutterOttuSdkFile, exist: ${flutterOttuSdkFile?.exists()}")

if (flutterOttuSdkFile?.exists() == true) {
    val gradleBuildContent = flutterOttuSdkFile.readLines()
    val isDependencyExist = gradleBuildContent.any { line ->

        //uncomment this line for remote usage
        /*line.contains("""implementation("com.github.ottuco:ottu-flutter-android:1.0.1")""") && !line.trim()
            .startsWith("//")*/

        line.contains("""implementation("com.ottu.checkout:ottu-flutter-checkout:1.0.7")""") && !line.trim()
            .startsWith("//")
    }
    if (isDependencyExist) {
        println("Sample App - Has flutter ottu local project dependency, includeBuild: ${flutterOttuSdkPath}")
        includeBuild(flutterOttuSdkPath!!)
    } else {
        println("Sample App - Has no ottu local project dependency")
    }
} else {
    println("Sample App - otu sdk file has not found at $flutterOttuSdkFile")
}

include(":app")

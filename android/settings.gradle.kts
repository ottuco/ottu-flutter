import java.io.FileInputStream
import java.io.FileNotFoundException
import java.util.Properties


val flutterProjectRoot = rootDir.toPath().parent


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

    val flutterSdkPath: String? = "/Users/vi/Downloads/flutter"
    //val flutterSdkPath: String? = localProperties.getProperty("flutter.sdk")
    assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
        flatDir {
            dirs = setOf(file("libs"))
        }
    }
}


/*pluginManagement {

    val flutterSdkPath = localProperties.getProperty("flutter.sdk")
    assert(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}*/

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "7.3.1" apply false
    id("com.android.library") version "7.3.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.23" apply false
    id("org.jetbrains.kotlin.plugin.parcelize") version "1.9.23" apply false
    id("com.google.devtools.ksp") version "1.9.23-1.0.19" apply false
}

include(":app")

// Check if :ottu-android-checkout is included as a dependency
val appBuildGradleFile = File(rootProject.projectDir, "app/build.gradle.kts")

val ottuSdkPath: String? = localProperties.getProperty("ottuSdk")

dependencyResolutionManagement {
    versionCatalogs {
        create("libs") {
            from(files("${ottuSdkPath?.substring(0, ottuSdkPath.lastIndexOf("/"))}/gradle/libs.versions.toml"))

            version("agp", "7.3.1")
            //version("kotlin", "2.0.20")
        }

    }
}

if (appBuildGradleFile.exists()) {
    val buildGradleContent = appBuildGradleFile.readLines()
    val isDependencyExist = buildGradleContent.any { line ->
        line.contains("""implementation(project(":ottu-android-checkout"))""") && !line.trim()
            .startsWith("//")
    }
    if (isDependencyExist) {
        if (ottuSdkPath == null) {
            throw GradleException(
                "Property 'ottuSdk' not found in local.properties. " +
                        "Use this: \"ottuSdk=/path/to/your/ottu-android-checkout/app\" with the actual path to your module."
            )
        } else {
            println("Has ottu sdk: $ottuSdkPath")
        }
        include(":ottu-android-checkout")
        project(":ottu-android-checkout").projectDir = File(ottuSdkPath)
    }
}
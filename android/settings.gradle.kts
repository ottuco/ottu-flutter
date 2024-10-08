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
    id("com.android.application") version "8.3.2" apply false
    id("org.jetbrains.kotlin.android") version "2.0.20" apply false
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
val appBuildGradleFile = File(rootProject.projectDir, "app/build.gradle.kts")
val ottuSdkPath: String? = localProperties.getProperty("ottuSdk")
val ottuSdkFile = ottuSdkPath?.let { File(ottuSdkPath, "build.gradle.kts") }
//println("Gradle build file: $appBuildGradleFile")
println("Ottu sdk build file: $ottuSdkFile")

if (ottuSdkFile != null) {
    //println("Gradle build file: $appBuildGradleFile")
    //val buildGradleContent = appBuildGradleFile.readLines()
    val ottuSdkContent = ottuSdkFile.readLines()
    //val isDependencyExist = buildGradleContent.any { line ->
    val isDependencyExist = ottuSdkContent.any { line ->
        /*line.contains("""implementation(project(":ottu-flutter-checkout"))""") && !line.trim()
            .startsWith("//")*/
        line.contains("""implementation("com.ottu.checkout:ottu-android-checkout:1.0.3")""") && !line.trim()
            .startsWith("//")
    }
    if (isDependencyExist) {
        println("Has ottu local project dependency, includeBuild: $ottuSdkPath")
        includeBuild(ottuSdkPath!!)
    }
} else {
    println("otu sdk file has not found at $appBuildGradleFile")
}

include(":app")

/*
val flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

val pluginsProperties = Properties()
val pluginsFile = File(flutterProjectRoot.toFile(), ".flutter-plugins").toPath()

if (Files.exists(pluginsFile)) {
    Files.newBufferedReader(pluginsFile).use { reader ->
        pluginsProperties.load(reader)
    }
}

pluginsProperties.forEach{ name, path ->
    val pluginDirectory = flutterProjectRoot.resolve(path as String).resolve("android").toFile()
    val settings = flutterProjectRoot.resolve(path).resolve("android/settings.gradle.kts").toFile()
    include(":$name")
    project(":$name").projectDir = pluginDirectory

    if (settings.exists()) {
        apply(settings)
    }
}*/

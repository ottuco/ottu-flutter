import java.nio.file.Files
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Base64
import java.util.Properties
import com.android.build.api.artifact.SingleArtifact

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties").toPath()
if (Files.exists(localPropertiesFile)) {
    Files.newBufferedReader(localPropertiesFile).use { reader ->
        localProperties.load(reader)
    }
}

val ABI_FILTERS = "armeabi-v7a"
val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileSdk = 37
    namespace = "com.ottu.sample"
    lint {
        abortOnError = false
        ignoreWarnings = true
        checkDependencies = false
    }

    defaultConfig {
        applicationId = "com.ottu.sample"
        minSdk = 26
        targetSdk = 37
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName

        ndk {
            // Filter for architectures supported by Flutter
            //abiFilters += listOf("armeabi-v7a", "arm64-v8a")
        }
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
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true // Enable code shrinking and obfuscation
            isShrinkResources = false // Enable resource shrinking
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    buildFeatures {
        viewBinding = true
    }
}

// Flutter forwards values from --dart-define-from-file as Base64 dart-defines.
val merchantId = providers.gradleProperty("dart-defines").orNull
    ?.split(",")
    ?.map { String(Base64.getDecoder().decode(it), Charsets.UTF_8) }
    ?.lastOrNull { it.startsWith("MERCHANT_ID=") }
    ?.substringAfter("=")
    .orEmpty()

val outputAppName = "FlutterAndroid"

// Keep ':' in the requested timestamp, but prevent names from creating paths.
fun outputNamePart(value: String) = value.replace(Regex("[/\\\\\\r\\n]"), "_")

val outputTimestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd_MM_yyyy_HH:mm"))

androidComponents {
    onVariants(selector().all()) { variant ->
        val variantTaskName = variant.name.replaceFirstChar { it.uppercaseChar() }
        val flavor = variant.flavorName?.takeIf { it.isNotEmpty() } ?: variant.buildType.orEmpty()
        val outputBaseName = "${outputNamePart(outputAppName)}_${outputNamePart(flavor)}_" +
            "${outputNamePart(merchantId)}_$outputTimestamp"

        val namedApk = tasks.register<Copy>("copy${variantTaskName}NamedApk") {
            from(variant.artifacts.get(SingleArtifact.APK))
            include("*.apk")
            into(layout.buildDirectory.dir("outputs/flutter-apk"))
            rename { originalName ->
                // Split APKs must retain their ABI to avoid overwriting each other.
                val abi = Regex("(?:armeabi-v7a|arm64-v8a|x86_64|x86)").find(originalName)?.value
                "$outputBaseName${abi?.let { "_$it" }.orEmpty()}.apk"
            }
        }
        val namedBundle = tasks.register<Copy>("copy${variantTaskName}NamedBundle") {
            from(variant.artifacts.get(SingleArtifact.BUNDLE))
            into(layout.buildDirectory.dir("outputs/named-bundle/${variant.name}"))
            rename { "$outputBaseName.aab" }
        }

        // Preserve Flutter's standard artifacts so flutter build/run can find them.
        tasks.matching { it.name == "assemble$variantTaskName" }.configureEach {
            finalizedBy(namedApk)
        }
        tasks.matching { it.name == "bundle$variantTaskName" }.configureEach {
            finalizedBy(namedBundle)
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
    }
}

allprojects {
    repositories {
        maven { url = uri("https://www.jitpack.io") }
    }
}

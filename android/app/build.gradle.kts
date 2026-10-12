plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

import java.util.Properties
import java.io.FileInputStream
import java.util.Base64

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
val hasReleaseSigningConfig = listOf(
    "keyAlias",
    "keyPassword",
    "storeFile",
    "storePassword",
).all { keystoreProperties.getProperty(it)?.isNotBlank() == true }

android {
    namespace = "com.tybetogo.driver"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.taybgo.driver"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "TaybGo Driver Dev")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "TaybGo Driver")
        }
    }

    signingConfigs {
        if (hasReleaseSigningConfig) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigningConfig) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }

}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

fun decodedDartDefines(rawDefines: String?): Map<String, String> =
    rawDefines
        .orEmpty()
        .split(',')
        .mapNotNull { encoded ->
            runCatching {
                String(Base64.getDecoder().decode(encoded))
            }.getOrNull()
        }
        .mapNotNull { define ->
            val separator = define.indexOf('=')
            if (separator <= 0) null
            else define.substring(0, separator) to define.substring(separator + 1)
        }
        .toMap()

// Never produce a release APK/App Bundle with a disabled address step.
tasks.configureEach {
    if (name.startsWith("compileFlutterBuild") && name.endsWith("Release")) {
        doFirst {
            val googlePlacesApiKey = decodedDartDefines(
                project.findProperty("dart-defines")?.toString(),
            )["GOOGLE_MAPS_API_KEY"]?.trim()
            if (
                googlePlacesApiKey == null ||
                !Regex("^AIza[0-9A-Za-z_-]{20,}$").matches(googlePlacesApiKey)
            ) {
                throw GradleException(
                    "Release build blocked: GOOGLE_MAPS_API_KEY is missing or invalid. " +
                        "Use --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY.",
                )
            }
        }
    }
}

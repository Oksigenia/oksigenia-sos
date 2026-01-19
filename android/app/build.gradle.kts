plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 1. IMPORTACIONES NECESARIAS PARA LEER EL KEYSTORE
import java.util.Properties
import java.io.FileInputStream

// 2. CARGAR EL ARCHIVO key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// --- NUEVO: BLOQUEAR LIBRERÍAS DE GOOGLE (CRÍTICO PARA F-DROID) ---
// Esto evita que 'geolocator' meta código propietario de Google en tu APK.
configurations.all {
    exclude(group = "com.google.android.gms", module = "play-services-location")
}
// ------------------------------------------------------------------

android {
    namespace = "com.oksigenia.oksigenia_sos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // --- NUEVO: OCULTAR METADATOS DE DEPENDENCIAS A GOOGLE ---
    dependenciesInfo {
        includeInApk = false
        includeInBundle = false
    }
    // ---------------------------------------------------------

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.oksigenia.oksigenia_sos"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 3. DEFINIR LA CONFIGURACIÓN DE FIRMA (RELEASE)
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            // 4. APLICAR LA FIRMA DE RELEASE
            signingConfig = signingConfigs.getByName("release")
            
            // Mantenemos esto en false para evitar problemas con la ofuscación del servicio en foreground
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

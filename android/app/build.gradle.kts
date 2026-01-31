plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 1. IMPORTACIONES NECESARIAS
import java.util.Properties
import java.io.FileInputStream

// 2. CARGAR EL ARCHIVO key.properties (SOLO SI EXISTE)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// --- BLOQUEAR LIBRERÍAS DE GOOGLE (CRÍTICO PARA F-DROID) ---
configurations.all {
    exclude(group = "com.google.android.gms", module = "play-services-location")
}
// -----------------------------------------------------------

android {
    namespace = "com.oksigenia.oksigenia_sos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        // CORRECCIÓN: Sintaxis Kotlin requiere 'is' y el signo '='
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // --- OCULTAR METADATOS DE DEPENDENCIAS A GOOGLE ---
    dependenciesInfo {
        includeInApk = false
        includeInBundle = false
    }

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

    // 3. DEFINIR LA CONFIGURACIÓN DE FIRMA (CONDICIONAL)
    signingConfigs {
        // Solo creamos la config "release" si hemos cargado las propiedades
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        getByName("release") {
            // 4. APLICAR LA FIRMA DE RELEASE (SOLO SI EXISTE)
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
            
            // Mantenemos esto en false para evitar problemas con la ofuscación
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

// CORRECCIÓN: Bloque de dependencias necesario para el desugaring en Kotlin DSL
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
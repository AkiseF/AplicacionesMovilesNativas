plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.practica_3"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Configuración para Gestor de Archivos - Práctica 3
        applicationId = "com.escom.ipn.gestor_archivos_practica3"
        
        // API mínima: Android 7.0 (API 24) según especificaciones
        minSdk = 24
        targetSdk = 34  // Android 14 para máxima compatibilidad
        
        // Información de versión descriptiva
        versionCode = 1
        versionName = "1.0.0-practica3"
        
        // Configuración adicional para APK descriptiva
        setProperty("archivesBaseName", "GestorArchivos-Practica3-v$versionName")
    }

    buildTypes {
        release {
            // Configuración para APK de producción
            signingConfig = signingConfigs.getByName("debug")
            
            // Deshabilitar optimizaciones que pueden causar problemas
            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = false
        }
        
        debug {
            // Configuración para APK de debug
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
            isDebuggable = true
        }
    }
}

flutter {
    source = "../.."
}

buildscript {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    dependencies {
        // Plugin Google Services pour Firebase
        classpath("com.google.gms:google-services:4.3.15") // Mets à jour si besoin

        // Plugin Kotlin Gradle
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Mets à jour vers la dernière version
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuration du répertoire de build
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

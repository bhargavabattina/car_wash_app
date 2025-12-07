buildscript {
<<<<<<< HEAD
    val kotlin_version by extra("1.8.22")
=======
    val kotlin_version = "1.8.22"
>>>>>>> bd04587 (changes)
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
<<<<<<< HEAD
        classpath ("com.android.tools.build:gradle:8.1.0")
        classpath ("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
        // Add Google Services plugin
        classpath ("com.google.gms:google-services:4.4.0")
=======
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${kotlin_version}")
        classpath("com.google.gms:google-services:4.4.0")
>>>>>>> bd04587 (changes)
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")
subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

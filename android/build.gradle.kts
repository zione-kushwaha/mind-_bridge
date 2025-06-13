buildscript {
    extra["kotlin_version"] = "1.8.10"
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    configurations.all {
        resolutionStrategy {
            force("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.10")
            force("org.jetbrains.kotlin:kotlin-stdlib:1.8.10")
            force("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.10")
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
